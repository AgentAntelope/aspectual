# frozen_string_literal: true

require_relative '../../lib/aspectual'

describe Aspectual do
  class TestClass
    extend Aspectual

    attr_reader :methods_called

    def initialize
      # This is to ensure that all methods are properly called within the
      # context of the current instance of this object.
      @methods_called = []
    end

    def kwarg_aspect_method(**kwargs)
      methods_called << "kwarg_aspect_method_kwargs_#{kwargs.to_a.join('_')}"
      self
    end

    def kwarg_around_aspect_method(**kwargs)
      methods_called << "before_block_kwarg_around_aspect_method_kwargs_#{kwargs.to_a.join('_')}"
      yield
      methods_called << "after_block_kwarg_around_aspect_method_kwargs_#{kwargs.to_a.join('_')}"
      self
    end

    aspects before: :kwarg_aspect_method
    def before_kwarg_test_method(**kwargs)
      methods_called << "before_kwarg_test_method_kwargs_#{kwargs.to_a.join('_')}"
      self
    end

    aspects around: :kwarg_around_aspect_method
    def around_kwarg_test_method(**kwargs)
      methods_called << "around_kwarg_test_method_kwargs_#{kwargs.to_a.join('_')}"
      self
    end

    aspects after: :kwarg_aspect_method
    def after_kwarg_test_method(**kwargs)
      methods_called << "after_kwarg_test_method_kwargs_#{kwargs.to_a.join('_')}"
      self
    end
  end

  describe 'methods with kwarg arguments' do
    it 'can handle before aspects' do
      test_instance = TestClass.new.before_kwarg_test_method(kwarg_1: :val_1, kwarg_2: :val_2)
      expect(test_instance.methods_called).to eq(%w[
                                                   kwarg_aspect_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
                                                   before_kwarg_test_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
                                                 ])
    end

    it 'can handle around aspects' do
      test_instance = TestClass.new.around_kwarg_test_method(kwarg_1: :val_1, kwarg_2: :val_2)
      expect(test_instance.methods_called).to eq(%w[
                                                   before_block_kwarg_around_aspect_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
                                                   around_kwarg_test_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
                                                   after_block_kwarg_around_aspect_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
                                                 ])
    end

    it 'can handle after aspects' do
      test_instance = TestClass.new.after_kwarg_test_method(kwarg_1: :val_1, kwarg_2: :val_2)
      expect(test_instance.methods_called).to eq(%w[
                                                   after_kwarg_test_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
                                                   kwarg_aspect_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
                                                 ])
    end
  end
end
