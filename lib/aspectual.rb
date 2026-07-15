#!/usr/bin/env ruby
# frozen_string_literal: true

module Aspectual
  VALID_ASPECTS = [
    BEFORE_ASPECT = :before,
    AFTER_ASPECT  = :after,
    AROUND_ASPECT = :around,
  ].freeze

  BLANK_ASPECT = {
    BEFORE_ASPECT => [].freeze,
    AROUND_ASPECT => [].freeze,
    AFTER_ASPECT => [].freeze,
  }.freeze

  NEXT_METHOD_ADDED_KEY = :_next_method_added

  # Special default value for next method added
  DEFAULT_ASPECTS = { NEXT_METHOD_ADDED_KEY => BLANK_ASPECT }.freeze

  def aspects(*method_names, before: [], around: [], after: [])
    method_names = [NEXT_METHOD_ADDED_KEY] if method_names.empty?
    method_names.each do |method_name|
      merge_aspects(
        method_name:,
        new_aspects: {
          BEFORE_ASPECT => Array(before),
          AROUND_ASPECT => Array(around),
          AFTER_ASPECT => Array(after),
        },
      )

      # If we already defined the method we're adding aspects for, we need to
      # process that straight away.
      add_aspects_to_method(method_name:) if instance_methods.include?(method_name)
    end
  end

  def method_added(method_name)
    add_aspects_to_method(method_name:)

    super
  end

  def defined_aspects
    return @_aspects if defined?(@_aspects)

    aspected_ancestor = ancestors[1..].detect do |klass|
      klass.is_a?(Aspectual)
    end

    return @_aspects ||= DEFAULT_ASPECTS unless aspected_ancestor

    @_aspects = aspected_ancestor.defined_aspects.dup
  end

  private

  def add_aspects_to_method(method_name:)
    merge_aspects(
      method_name:,
      new_aspects: defined_aspects.fetch(NEXT_METHOD_ADDED_KEY, BLANK_ASPECT),
    )

    aspects_to_add = defined_aspects[method_name]

    # If there are no defined aspects we have nothing to do
    return unless aspects_to_add&.any? { |_aspect, methods| methods.any? }
    return if @_defining_method

    # Blank out the aspects for the next method added
    defined_aspects[NEXT_METHOD_ADDED_KEY] = BLANK_ASPECT

    return unless method_defined?(method_name)

    # Remove the aspects for this method, in case we see multiple definitions
    # of a single method (i.e. inheritance)
    defined_aspects.delete(method_name)

    VALID_ASPECTS.each do |position|
      aspects_to_add[position].map do |aspect|
        define_aspect_method(method_name:, position:, aspect:)
      end
    end
  end

  def define_aspect_method(method_name:, position:, aspect:)
    # This is to prevent us from looping because we're about to define some
    # methods.
    @_defining_method = true

    with_method_name = with_aspect_method_name(
      target: method_name, position:, feature: aspect,
    )

    with_method_proc = build_with_method_proc(aspect:, position:, method_name:)

    define_method(with_method_name, with_method_proc)

    scope_method_to_parent(
      scope_method_name: method_name,
      new_method_name: with_method_name,
    )

    alias_method_chain(target: method_name, feature: aspect, position:)

    @_defining_method = false
  end

  def build_with_method_proc(aspect:, position:, method_name:)
    without_method_name = without_aspect_method_name(
      target: method_name, position:, feature: aspect,
    )

    case position
    when BEFORE_ASPECT
      lambda do |*args, **kwargs, &blk|
        # first, call the aspect
        send(aspect, *args, **kwargs, &blk)

        # then, call the method without the aspect
        send(without_method_name, *args, **kwargs, &blk)
      end
    when AROUND_ASPECT
      lambda do |*args, **kwargs, &blk|
        send(aspect, *args, **kwargs, &proc do
          send(without_method_name, *args, **kwargs, &blk)
        end)
      end
    when AFTER_ASPECT
      lambda do |*args, **kwargs, &blk|
        # first, call the method without the aspect
        send(without_method_name, *args, **kwargs, &blk)

        # then, call the aspect
        send(aspect, *args, **kwargs, &blk)
      end
    end
  end

  def scope_method_to_parent(scope_method_name:, new_method_name:)
    if public_method_defined?(scope_method_name)
      public new_method_name
    elsif protected_method_defined?(scope_method_name)
      protected new_method_name
    elsif private_method_defined?(scope_method_name)
      private new_method_name
    end
  end

  # adapted from ActiveSupport
  def alias_method_chain(target:, feature:, position:)
    with_method_name = with_aspect_method_name(target:, position:, feature:)
    without_method_name = without_aspect_method_name(target:, position:, feature:)

    alias_method(without_method_name, target)
    alias_method(target, with_method_name)

    scope_method_to_parent(
      scope_method_name: without_method_name,
      new_method_name: target,
    )
  end

  def with_aspect_method_name(target:, position:, feature:, punctuation: nil)
    target, punctuation = *safe_target(target:)

    # Produce something like: :target_with_position_feature (with possible
    # punctuation on the end)
    :"#{target}_with_#{position}_#{feature}#{punctuation}"
  end

  def without_aspect_method_name(target:, position:, feature:, punctuation: nil)
    target, punctuation = *safe_target(target:)

    # Produce something like: :target_without_position_feature (with possible
    # punctuation on the end)
    :"#{target}_without_#{position}_#{feature}#{punctuation}"
  end

  def safe_target(target:)
    # Extract punctuation on methods ending in one of !, ?, or = since e.g.
    # target?_without_position_feature should properly be
    # target_without_position_feature?.
    target.to_s.scan(/(.*)([?!=])?$/).flatten
  end

  def merge_aspects(method_name:, new_aspects:)
    return defined_aspects if new_aspects == BLANK_ASPECT

    @_aspects = defined_aspects.merge({ method_name => new_aspects }) do |_aspected_method_name, old_config, new_config|
      old_config.merge(new_config) do |aspect, old_aspects, new_aspects|
        case aspect
        when BEFORE_ASPECT, AROUND_ASPECT
          # The before and around aspects have to be reversed so that when
          # multiple aspects are added to one method, the first declared method
          # will be added last.
          (new_aspects.reverse + old_aspects).uniq
        else
          (old_aspects + new_aspects).uniq
        end
      end
    end
  end
end
