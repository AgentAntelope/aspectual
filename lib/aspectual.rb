#!/usr/bin/env ruby

module Aspectual
  VALID_ASPECTS = [
    BEFORE_ASPECT = :before,
    AFTER_ASPECT  = :after,
    AROUND_ASPECT = :around,
  ].freeze

  def aspects(aspects)
    # The before and around aspects have to be reversed so that when multiple
    # aspects are added to one method, the first declared method will be added
    # last.
    @_before_aspects = Array(aspects[BEFORE_ASPECT]).reverse
    @_around_aspects = Array(aspects[AROUND_ASPECT]).reverse
    @_after_aspects  = Array(aspects[AFTER_ASPECT])
  end

  def method_added(method_name)
    return unless has_aspects_declared?
    return if @_defining_method
    if method_defined?(method_name)

      VALID_ASPECTS.each do |position|
        current_aspects = instance_variable_get("@_#{position}_aspects")
        if current_aspects
          current_aspects.each do |aspect|
            define_aspect_method(method_name:, position:, aspect:)
          end
        end
      end
    end
  end

  private

  def has_aspects_declared?
    @_before_aspects || @_after_aspects
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
        send(aspect, *args, **kwargs, &blk)

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
        send(without_method_name, *args, **kwargs, &blk)

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

    # produces something like: :foo_with_before_logging?
    :"#{target}_with_#{position}_#{feature}#{punctuation}"
  end

  def without_aspect_method_name(target:, position:, feature:, punctuation: nil)
    target, punctuation = *safe_target(target:)

    # produces something like: :foo_without_before_logging?
    :"#{target}_without_#{position}_#{feature}#{punctuation}"
  end

  def safe_target(target:)
    # Strip out punctuation on methods ending in one of !, ?, or = since e.g.
    # target?_without_position_feature is not a valid method name. Since we only
    # call this method with the name of a method that has been added, there's no
    # need to validate further that the rest of the method name is valid.
    target.to_s.scan(/(.*)([?!=])?$/).flatten
  end
end
