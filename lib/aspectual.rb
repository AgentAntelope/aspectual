#!/usr/bin/env ruby
# frozen_string_literal: true

# Aspectual allows Aspect Oriented Programming in Ruby.
module Aspectual
  require_relative 'aspectual/method_construction'

  include MethodConstruction

  # This order is important to ensure we're assigning aspects in the correct
  # order: Before comes before around, so needs to be added to the method after
  VALID_ASPECTS = [
    AROUND_ASPECT = :around,
    BEFORE_ASPECT = :before,
    AFTER_ASPECT  = :after,
  ].freeze

  BLANK_ASPECT = VALID_ASPECTS.to_h { [_1, [].freeze] }.freeze

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
      next unless method_defined?(method_name) || private_method_defined?(method_name)

      add_aspects_to_method(method_name:)
    end
  end

  def method_added(method_name)
    add_aspects_to_method(method_name:)

    super
  end

  def defined_aspects
    return @defined_aspects if defined?(@defined_aspects)

    aspected_ancestor = ancestors[1..].detect do |klass|
      klass.is_a?(Aspectual)
    end

    @defined_aspects = Marshal.load(
      Marshal.dump(
        aspected_ancestor&.defined_aspects || DEFAULT_ASPECTS,
      ),
    )
  end

  private

  attr_writer :defined_aspects

  def can_define_aspect?(aspects:, method_name:)
    # If there are no defined aspects we have nothing to do
    aspects.values.any?(&:any?) &&
      # the method we're adding aspects to needs to have been defined
      (method_defined?(method_name) || private_method_defined?(method_name))
  end

  def add_aspects_to_method(method_name:)
    return if @_defining_method

    aspects = calculate_aspects(method_name:)

    return unless can_define_aspect?(aspects:, method_name:)

    # Remove the aspects for this method, in case we see multiple definitions
    # of a single method (i.e. inheritance)
    defined_aspects.delete(method_name)

    aspects.each do |position, positional_aspects|
      positional_aspects.each do |aspect|
        define_aspect_method(method_name:, position:, aspect:)
      end
    end
  end

  def calculate_aspects(method_name:)
    merge_aspects(
      method_name:,
      new_aspects: defined_aspects.fetch(NEXT_METHOD_ADDED_KEY, BLANK_ASPECT),
    )

    # Blank out the aspects for the next method added
    defined_aspects[NEXT_METHOD_ADDED_KEY] = BLANK_ASPECT

    defined_aspects[method_name] || BLANK_ASPECT
  end

  def merge_aspects(method_name:, new_aspects:)
    return defined_aspects if new_aspects == BLANK_ASPECT

    self.defined_aspects = defined_aspects.merge(
      { method_name => new_aspects },
    ) do |_aspected_method_name, old_config, new_config|
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
