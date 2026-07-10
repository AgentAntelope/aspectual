#!/usr/bin/env ruby

module Aspectual
  VALID_ASPECTS = [
    BEFORE_ASPECT = :before,
    AFTER_ASPECT  = :after,
    AROUND_ASPECT = :around,
  ].freeze

  def aspects(before: [], around: [], after: [])
    # The before and around aspects have to be reversed so that when multiple
    # aspects are added to one method, the first declared method will be added
    # last.
    @_aspects = {
      BEFORE_ASPECT => Array(before).reverse,
      AROUND_ASPECT => Array(around).reverse,
      AFTER_ASPECT  => Array(after),
    }
  end

  def method_added(method_name)
    # If there are no defined aspects we have nothing to do
    return unless @_aspects&.any? {|aspect, methods| methods.any? }
    return if @_defining_method

    if method_defined?(method_name)

      VALID_ASPECTS.each do |position|
        @_aspects[position]&.map do |aspect|
          define_aspect_method(method_name:, position:, aspect:)
        end

        # Once a method is defined, we need to clear the aspects out to avoid
        # polluting subsequent method definitions. If you're defining multiple
        # methods in a loop that will mean you'll need to call .aspects multiple
        # times, but if you're doing that sort of thing then I assume you're
        # comfortable with a little discomfort.
        @_aspects[position] = []
      end
    end
  end

  private

  def define_aspect_method(method_name:, position:, aspect:)
    # This is to prevent us from looping because we're about to define some
    # methods.
    @_defining_method = true

    with_method_name = with_aspect_method_name(
      target: method_name, position:, feature: aspect,
    )

    with_method_proc = build_with_method_proc(aspect:, position:, method_name:)

    define_method(with_method_name, with_method_proc)

    scope_method_to_parent(method_name, with_method_name)

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
        send(aspect, *args, **kwargs, &Proc.new do
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

  def scope_method_to_parent(without_method, target)
    case
    when public_method_defined?(without_method)
      public target
    when protected_method_defined?(without_method)
      protected target
    when private_method_defined?(without_method)
      private target
    end
  end

  # adapted from ActiveSupport
  def alias_method_chain(target:, feature:, position:)
    with_method_name = with_aspect_method_name(target:, position:, feature:)
    without_method_name = without_aspect_method_name(target:, position:, feature:)

    alias_method(without_method_name, target)
    alias_method(target, with_method_name)

    scope_method_to_parent(without_method_name, target)
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
end
