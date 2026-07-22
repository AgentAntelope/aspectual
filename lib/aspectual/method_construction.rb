# frozen_string_literal: true

module Aspectual
  # Used to build up aspect methods to replace the methods Aspectual wraps
  module MethodConstruction
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
        before_lambda(aspect:, without_method_name:)
      when AROUND_ASPECT
        around_lambda(aspect:, without_method_name:)
      when AFTER_ASPECT
        after_lambda(aspect:, without_method_name:)
      end
    end

    def before_lambda(aspect:, without_method_name:)
      lambda do |*args, **kwargs, &blk|
        # first, call the aspect
        send(aspect, *args, **kwargs, &blk)

        # then, call the method without the aspect
        send(without_method_name, *args, **kwargs, &blk)
      end
    end

    def around_lambda(aspect:, without_method_name:)
      lambda do |*args, **kwargs, &blk|
        send(aspect, *args, **kwargs, &proc do
          send(without_method_name, *args, **kwargs, &blk)
        end)
      end
    end

    def after_lambda(aspect:, without_method_name:)
      lambda do |*args, **kwargs, &blk|
        # first, call the method without the aspect
        send(without_method_name, *args, **kwargs, &blk)

        # then, call the aspect
        send(aspect, *args, **kwargs, &blk)
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

    def with_aspect_method_name(target:, position:, feature:)
      target, punctuation = *safe_target(target:)

      # Produce something like: :target_with_position_feature (with possible
      # punctuation on the end)
      :"#{target}_with_#{position}_#{feature}#{punctuation}"
    end

    def without_aspect_method_name(target:, position:, feature:)
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
end
