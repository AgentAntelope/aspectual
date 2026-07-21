#!/usr/bin/env ruby
# frozen_string_literal: true

module Aspectual
  VALID_ASPECTS = [
    BEFORE_ASPECT = :before,
    AFTER_ASPECT  = :after,
  ].freeze

  BLANK_ASPECT = {
    BEFORE_ASPECT => [].freeze,
    AFTER_ASPECT => [].freeze,
  }.freeze

  NEXT_METHOD_ADDED_KEY = :_next_method_added

  # Special default value for next method added
  DEFAULT_ASPECTS = { NEXT_METHOD_ADDED_KEY => BLANK_ASPECT }.freeze

  def aspects(*method_names, before: [], after: [])
    method_names = [NEXT_METHOD_ADDED_KEY] if method_names.empty?
    method_names.each do |method_name|
      merge_aspects(
        method_name:,
        new_aspects: {
          BEFORE_ASPECT => Array(before),
          AFTER_ASPECT => Array(after),
        },
      )

      # If we haven't already defined the method we're adding aspects for, we
      # need to wait until that method is added
      next unless (instance_methods + private_instance_methods).include?(method_name)

      add_aspects_to_method(method_name:)
    end
  end

  def method_added(method_name)
    add_aspects_to_method(method_name:)

    # Find all of the methods with this aspect, in case we're adding a method
    # that is an aspect and as a result we need to set TracePoints for the
    # method the aspect relates to.
    methods_with_aspect = defined_aspects.select do |_aspected_method, aspects|
      aspects.any? do |_position, aspect_methods|
        aspect_methods.any? do |aspect_method|
          aspect_method == method_name
        end
      end
    end.keys

    methods_with_aspect.map do |aspected_method|
      add_aspects_to_method(method_name: aspected_method)
    end

    super
  end

  def defined_aspects
    return @defined_aspects if defined?(@defined_aspects)

    aspected_ancestor = ancestors[1..].detect do |klass|
      klass.is_a?(Aspectual)
    end

    return @defined_aspects ||= DEFAULT_ASPECTS unless aspected_ancestor

    # Dump and load the aspects to create a deep clone of the aspect definitions
    @defined_aspects = Marshal.load(Marshal.dump(
                                      aspected_ancestor.defined_aspects,
                                    ))
  end

  private

  attr_writer :defined_aspects

  def add_aspects_to_method(method_name:)
    merge_aspects(
      method_name:,
      new_aspects: defined_aspects.fetch(NEXT_METHOD_ADDED_KEY, BLANK_ASPECT),
    )

    aspects_to_add = defined_aspects[method_name]

    # If there are no defined aspects we have nothing to do
    return unless aspects_to_add&.any? { |_aspect, methods| methods.any? }

    # Blank out the aspects for the next method added
    defined_aspects[NEXT_METHOD_ADDED_KEY] = BLANK_ASPECT

    return unless method_defined?(method_name) || private_method_defined?(method_name)

    VALID_ASPECTS.each do |position|
      aspects_to_add[position].map do |aspect|
        # We can't add the aspect yet unless the instance actually has that
        # method defined on it
        next unless method_defined?(aspect) || private_method_defined?(aspect)

        define_aspect_method(method_name:, position:, aspect:)

        # Remove the aspect we've added from the list we need to add
        defined_aspects[method_name][position] = aspects_to_add[position] - [aspect]
      end
    end
  end

  def define_aspect_method(method_name:, position:, aspect:)
    case position
    when BEFORE_ASPECT
      define_before_aspect(method_name:, aspect:)
    when AFTER_ASPECT
      define_after_aspect(method_name:, aspect:)
    end
  end

  def define_before_aspect(method_name:, aspect:)
    # Configure a TracePoint that, when the aspected method is called, will bind
    # the aspect method to the receiver of that method and then call it.
    trace_point = TracePoint.new(:call) do |trace_point|
      # Ensure that we don't pollute ancestors with aspects defined on children
      next unless trace_point.binding.receiver.is_a?(binding.receiver)

      # Call the aspect on the receiver of this trace: because this TracePoint
      # is on method call, this means we're calling the aspect before the
      # method.
      call_aspect(aspect:, trace_point:)
    end

    trace_point.enable(target: instance_method(method_name))
  end

  def define_after_aspect(method_name:, aspect:)
    # Configure a TracePoint that, when the aspected method returns, will bind
    # the aspect method to the receiver of that method and then call it,
    # returning the original return value afterwards.
    trace_point = TracePoint.new(:return) do |trace_point|
      # Ensure that we don't pollute ancestors with aspects defined on children
      next unless trace_point.binding.receiver.is_a?(binding.receiver)

      # Call the aspect on the receiver of this trace: because this TracePoint
      # is on method return, this means we're calling the aspect after the
      # method.

      call_aspect(aspect:, trace_point:)
    end

    trace_point.enable(target: instance_method(method_name))
  end

  def merge_aspects(method_name:, new_aspects:)
    return defined_aspects if new_aspects == BLANK_ASPECT

    self.defined_aspects = defined_aspects.merge(
      { method_name => new_aspects },
    ) do |_aspected_method_name, old_config, new_config|
      old_config.merge(new_config) do |_aspect, old_aspects, new_aspects|
        # The aspects have to be reversed so that when multiple aspects are
        # added to one method, the first declared method will be added last.
        (new_aspects.reverse + old_aspects).uniq
      end
    end
  end

  def call_aspect(aspect:, trace_point:)
    params = construct_params(trace_point:)

    # Get the instance method UnboundMethod for our aspect, and call it on the
    # receiver of this trace: because this TracePoint is on return, this means
    # we're calling the aspect after the method.
    instance_method(aspect).bind_call(
      trace_point.binding.receiver,
      *params[:req],
      *params[:rest],
      **params[:keyreq],
      **params[:keyrest],
      &params[:block]
    )
  end

  # Take the local variable bindings of the trace_point and construct a params
  # mapping for calling the appropriate methods
  def construct_params(trace_point:)
    local_variables = trace_point.binding.local_variables.to_h do
      [_1, trace_point.binding.local_variable_get(_1)]
    end

    { req: [], rest: [], keyreq: {}, keyrest: {}, block: nil }.tap do |params|
      trace_point.parameters.to_h.each do |param_type, param_name|
        construct_param(local_variables:, params:, param_type:, param_name:)
      end
    end
  end

  def construct_param(local_variables:, params:, param_type:, param_name:)
    case param_type
    when :req
      params[:req] << local_variables[param_name]
    when :rest
      params[:rest] += local_variables[param_name]
    when :keyreq
      params[:keyreq].merge!({ param_name => local_variables[param_name] })
    when :keyrest
      params[:keyrest].merge!(local_variables[param_name] || {})
    when :block
      params[:block] = local_variables[param_name]
    end
  end
end
