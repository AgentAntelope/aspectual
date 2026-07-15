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

    def positional_aspect_method(*args)
      methods_called << "positional_aspect_method_args_#{args.join('_')}"
      self
    end

    def positional_around_aspect_method(*args)
      methods_called << "before_block_positional_around_aspect_method_args_#{args.join('_')}"
      yield
      methods_called << "after_block_positional_around_aspect_method_args_#{args.join('_')}"
      self
    end

    aspects before: :positional_aspect_method
    def before_positional_test_method(*args)
      methods_called << "before_positional_test_method_args_#{args.join('_')}"
      self
    end

    aspects around: :positional_around_aspect_method
    def around_positional_test_method(*args)
      methods_called << "before_positional_test_method_args_#{args.join('_')}"
      self
    end

    aspects after: :positional_aspect_method
    def after_positional_test_method(*args)
      methods_called << "after_positional_test_method_args_#{args.join('_')}"
      self
    end
  end

  describe 'methods with positional arguments' do
    it 'can handle before aspects' do
      test_instance = TestClass.new.before_positional_test_method('arg_1', 'arg_2')
      expect(test_instance.methods_called).to eq(%w[
                                                   positional_aspect_method_args_arg_1_arg_2
                                                   before_positional_test_method_args_arg_1_arg_2
                                                 ])
    end

    it 'can handle around aspects' do
      test_instance = TestClass.new.around_positional_test_method('arg_1', 'arg_2')
      expect(test_instance.methods_called).to eq(%w[
                                                   before_block_positional_around_aspect_method_args_arg_1_arg_2
                                                   before_positional_test_method_args_arg_1_arg_2
                                                   after_block_positional_around_aspect_method_args_arg_1_arg_2
                                                 ])
    end

    it 'can handle after aspects' do
      test_instance = TestClass.new.after_positional_test_method('arg_1', 'arg_2')
      expect(test_instance.methods_called).to eq(%w[
                                                   after_positional_test_method_args_arg_1_arg_2
                                                   positional_aspect_method_args_arg_1_arg_2
                                                 ])
    end
  end
end
