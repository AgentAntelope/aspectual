#!/usr/bin/env ruby

module Aspectual
  def aspects(aspects)
    # The before aspect have to be reversed so that when multiple before
    # aspects are added to one method, the first declared method will be
    # added last.
    @_before_aspects = Array(aspects[:before]).reverse
    @_around_aspects = Array(aspects[:around]).reverse
    @_after_aspects  = Array(aspects[:after])
  end

  def method_added(method_symbol)
    return unless has_aspects_declared?
    return if @_defining_method
    if method_defined?(method_symbol)

      %w{before around after}.each do |position|
        current_aspects = instance_variable_get("@_#{position}_aspects")
        if current_aspects
          current_aspects.each do |aspect|
            define_aspect_method(method_symbol, position, aspect)
          end
        end
      end
    end
  end

  private

  def has_aspects_declared?
    @_before_aspects || @_after_aspects
  end

  def define_aspect_method(method_symbol, position, aspect)
    # This is to prevent us from looping because we're about to define some methods.
    @_defining_method = true

    with_aspect_method_name = method_symbol.to_s + "_with_#{position}_" + aspect.to_s
    without_aspect_method_name = method_symbol.to_s + "_without_#{position}_" + aspect.to_s

    case position
    when "before"
      aspect_proc = lambda {|*args| send(aspect, *args); send(without_aspect_method_name, *args)}
    when "around"
      aspect_proc = lambda {|*args| send(aspect, *args, &Proc.new{send(without_aspect_method_name, *args)})}
    when "after"
      aspect_proc = lambda {|*args| send(without_aspect_method_name, *args); send(aspect, *args)}
    end

    define_method(with_aspect_method_name, aspect_proc)

    scope_method_to_parent(method_symbol, with_aspect_method_name)

    alias_method_chain(method_symbol, aspect.to_sym, position)

    @_defining_method = false
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

  # adapted from active support
  def alias_method_chain(target, feature, position)
    # Strip out punctuation on predicates or bang methods since
    # e.g. target?_without_position_feature is not a valid method name.
    aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1

    with_method = "#{aliased_target}_with_#{position}_#{feature}#{punctuation}"
    without_method = "#{aliased_target}_without_#{position}_#{feature}#{punctuation}"

    alias_method without_method, target
    alias_method target, with_method

    scope_method_to_parent(without_method, target)
  end
end
