# frozen_string_literal: true

require_relative '../../lib/aspectual'

class ReturnValueTestClass
  extend Aspectual

  attr_reader :methods_called

  def initialize
    # This is to ensure that all methods are properly called within the
    # context of the current instance of this object.
    @methods_called = []
  end

  # These definitions could be looped over to make this class shorter, but the
  # decision has been made to go for clarity over brevity.
  def single_test_method
    methods_called << 'single_test_method'
    'single_test_method'
  end

  def array_test_method_0
    methods_called << 'array_test_method_0'
    'array_test_method_0'
  end

  def array_test_method_1
    methods_called << 'array_test_method_1'
    'array_test_method_1'
  end

  def before_test_method_0
    methods_called << 'before_test_method_0'
    'before_test_method_0'
  end

  def before_test_method_1
    methods_called << 'before_test_method_1'
    'before_test_method_1'
  end

  def around_test_method_0
    methods_called << 'before_block_around_aspect_method_0'
    yield
    methods_called << 'after_block_around_aspect_method_0'
  end

  def around_test_method_1
    methods_called << 'before_block_around_aspect_method_1'
    yield
    methods_called << 'after_block_around_aspect_method_1'
  end

  def after_test_method_0
    methods_called << 'after_test_method_0'
    'after_test_method_0'
  end

  def after_test_method_1
    methods_called << 'after_test_method_1'
    'after_test_method_1'
  end

  aspects before: :single_test_method
  def single_before_test_method
    methods_called << 'single_before_test_method'
    'single_before_test_method'
  end

  aspects after: :single_test_method
  def single_after_test_method
    methods_called << 'single_after_test_method'
    'single_after_test_method'
  end

  aspects before: %i[array_test_method_0 array_test_method_1]
  def array_before_test_method
    methods_called << 'array_before_test_method'
    'array_before_test_method'
  end

  aspects before: :array_test_method_0
  aspects before: :array_test_method_1
  def multiple_before_test_method
    methods_called << 'multiple_before_test_method'
    'multiple_before_test_method'
  end

  def specific_before_test_method
    methods_called << 'specific_before_test_method'
    'specific_before_test_method'
  end
  aspects :specific_before_test_method, before: :single_test_method

  aspects after: %i[array_test_method_0 array_test_method_1]
  def array_after_test_method
    methods_called << 'array_after_test_method'
    'array_after_test_method'
  end

  aspects after: :array_test_method_0
  aspects after: :array_test_method_1
  def multiple_after_test_method
    methods_called << 'multiple_after_test_method'
    'multiple_after_test_method'
  end

  def specific_after_test_method
    methods_called << 'specific_after_test_method'
    'specific_after_test_method'
  end
  aspects :specific_after_test_method, after: :single_test_method

  aspects(
    before: %i[before_test_method_0 before_test_method_1],
    around: %i[around_test_method_0 around_test_method_1],
    after: %i[after_test_method_0 after_test_method_1],
  )
  def before_and_after_aspects_test_method
    methods_called << 'before_and_after_aspects_test_method'
    'before_and_after_aspects_test_method'
  end
end

describe Aspectual do
  describe 'before aspects do not change return value' do
    it 'calls before aspect methods before the called method' do
      test_instance = ReturnValueTestClass.new
      result = test_instance.single_before_test_method
      expect(result).to eq('single_before_test_method')
    end

    it 'can be defined for a specific method' do
      test_instance = ReturnValueTestClass.new
      result = test_instance.specific_before_test_method
      expect(result).to eq('specific_before_test_method')
    end

    it 'allows multiple aspects to be declared' do
      test_instance = ReturnValueTestClass.new
      result = test_instance.array_before_test_method
      expect(result).to eq('array_before_test_method')
    end

    it 'allows multiple aspects to be declared in separate calls' do
      test_instance = ReturnValueTestClass.new
      result = test_instance.multiple_before_test_method
      expect(result).to eq('multiple_before_test_method')
    end
  end

  describe 'after aspects do change return value' do
    it 'calls before aspect methods before the called method' do
      test_instance = ReturnValueTestClass.new
      result = test_instance.single_after_test_method
      expect(result).to eq('single_test_method')
    end

    it 'can be defined for a specific method' do
      test_instance = ReturnValueTestClass.new
      result = test_instance.specific_after_test_method
      expect(result).to eq('single_test_method')
    end

    it 'allows multiple aspects to be declared' do
      test_instance = ReturnValueTestClass.new
      result = test_instance.array_after_test_method
      expect(result).to eq('array_test_method_1')
    end

    it 'allows multiple aspects to be declared in separate calls' do
      test_instance = ReturnValueTestClass.new
      result = test_instance.multiple_after_test_method
      expect(result).to eq('array_test_method_1')
    end
  end

  describe 'mixed aspects' do
    it 'calls all the aspect declarations in the correct order' do
      test_instance = ReturnValueTestClass.new
      result = test_instance.before_and_after_aspects_test_method
      expect(result).to eq('after_test_method_1')
    end
  end
end
