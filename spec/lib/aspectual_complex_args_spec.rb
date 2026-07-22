# frozen_string_literal: true

require_relative '../../lib/aspectual'

class ComplexArgsTestClass
  extend Aspectual

  attr_reader :methods_called

  def initialize
    # This is to ensure that all methods are properly called within the
    # context of the current instance of this object.
    @methods_called = []
  end

  def all_params_aspect_method(arg_1, *args, kwarg_1:, **kwargs, &block)
    methods_called << "all_params_aspect_method_block_arg1_#{
        arg_1}_args_#{args.join('_')}_kwarg_1_#{kwarg_1}_#{
        kwargs.to_a.join('_')}_block_result_#{block.call}"

    self
  end

  def all_params_around_aspect_method(arg_1, *args, kwarg_1:, **kwargs, &block)
    methods_called << "before_block_block_around_aspect_method_block_arg1_#{
        arg_1}_args_#{args.join('_')}_kwarg_1_#{kwarg_1}_#{kwargs.to_a.join('_')}"

    block.call

    methods_called << "after_block_block_around_aspect_method_block_arg1_#{
        arg_1}_args_#{args.join('_')}_kwarg_1_#{kwarg_1}_#{kwargs.to_a.join('_')}"

    self
  end

  aspects before: :all_params_aspect_method
  def before_all_params_test_method(arg_1, *args, kwarg_1:, **kwargs, &block)
    methods_called << "before_all_params_test_method_block_arg1_#{
        arg_1}_args_#{args.join('_')}_kwarg_1_#{kwarg_1}_#{
        kwargs.to_a.join('_')}_block_result_#{block.call}"

    self
  end

  aspects around: :all_params_around_aspect_method
  def around_all_params_test_method(arg_1, *args, kwarg_1:, **kwargs, &block)
    methods_called << "around_all_params_test_method_block_arg1_#{
        arg_1}_args_#{args.join('_')}_kwarg_1_#{kwarg_1}_#{
        kwargs.to_a.join('_')}_block_result_#{block.call}"

    self
  end

  aspects after: :all_params_aspect_method
  def after_all_params_test_method(arg_1, *args, kwarg_1:, **kwargs, &block)
    methods_called << "after_all_params_test_method_block_arg1_#{
        arg_1}_args_#{args.join('_')}_kwarg_1_#{kwarg_1}_#{
        kwargs.to_a.join('_')}_block_result_#{block.call}"

    self
  end
end

describe Aspectual do
  describe 'methods with many complex arguments' do
    it 'can handle before aspects' do
      test_instance = ComplexArgsTestClass.new.before_all_params_test_method(
        'arg1',
        'arg2',
        kwarg_1: :val_1,
        kwarg_2: :val_2,
      ) { 'called' }

      expect(test_instance.methods_called).to eq(
        %w[
          all_params_aspect_method_block_arg1_arg1_args_arg2_kwarg_1_val_1_kwarg_2_val_2_block_result_called
          before_all_params_test_method_block_arg1_arg1_args_arg2_kwarg_1_val_1_kwarg_2_val_2_block_result_called
        ],
      )
    end

    it 'can handle around aspects' do
      test_instance = ComplexArgsTestClass.new.around_all_params_test_method(
        'arg1',
        'arg2',
        kwarg_1: :val_1,
        kwarg_2: :val_2,
      ) { 'called' }

      expect(test_instance.methods_called).to eq(
        %w[
          before_block_block_around_aspect_method_block_arg1_arg1_args_arg2_kwarg_1_val_1_kwarg_2_val_2
          around_all_params_test_method_block_arg1_arg1_args_arg2_kwarg_1_val_1_kwarg_2_val_2_block_result_called
          after_block_block_around_aspect_method_block_arg1_arg1_args_arg2_kwarg_1_val_1_kwarg_2_val_2
        ],
      )
    end

    it 'can handle after aspects' do
      test_instance = ComplexArgsTestClass.new.after_all_params_test_method(
        'arg1',
        'arg2',
        kwarg_1: :val_1,
        kwarg_2: :val_2,
      ) { 'called' }

      expect(test_instance.methods_called).to eq(
        %w[
          after_all_params_test_method_block_arg1_arg1_args_arg2_kwarg_1_val_1_kwarg_2_val_2_block_result_called
          all_params_aspect_method_block_arg1_arg1_args_arg2_kwarg_1_val_1_kwarg_2_val_2_block_result_called
        ],
      )
    end
  end
end
