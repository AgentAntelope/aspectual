# frozen_string_literal: true

require_relative '../../lib/aspectual'

class BlockArgsTestClass
  extend Aspectual

  attr_reader :methods_called

  def initialize
    # This is to ensure that all methods are properly called within the
    # context of the current instance of this object.
    @methods_called = []
  end

  def block_aspect_method(&block)
    methods_called << "block_aspect_method_block_result_#{block.call}"
    self
  end

  def block_around_aspect_method(&block)
    methods_called << 'before_block_block_around_aspect_method_block'
    block.call
    methods_called << 'after_block_block_around_aspect_method_block'
    self
  end

  aspects before: :block_aspect_method
  def before_block_test_method(&block)
    methods_called << "before_block_test_method_block_result_#{block.call}"
    self
  end

  aspects around: :block_around_aspect_method
  def around_block_test_method(&block)
    methods_called << "around_block_test_method_block_result_#{block.call}"
    self
  end

  aspects after: :block_aspect_method
  def after_block_test_method(&block)
    methods_called << "after_block_test_method_block_result_#{block.call}"
    self
  end
end

describe Aspectual do
  describe 'methods with block arguments' do
    it 'can handle before aspects' do
      test_instance = BlockArgsTestClass.new.before_block_test_method { 'called' }
      expect(test_instance.methods_called).to eq(%w[
                                                   block_aspect_method_block_result_called
                                                   before_block_test_method_block_result_called
                                                 ])
    end

    it 'can handle around aspects' do
      test_instance = BlockArgsTestClass.new.around_block_test_method { 'called' }
      expect(test_instance.methods_called).to eq(%w[
                                                   before_block_block_around_aspect_method_block
                                                   around_block_test_method_block_result_called
                                                   after_block_block_around_aspect_method_block
                                                 ])
    end

    it 'can handle after aspects' do
      test_instance = BlockArgsTestClass.new.after_block_test_method { 'called' }
      expect(test_instance.methods_called).to eq(%w[
                                                   after_block_test_method_block_result_called
                                                   block_aspect_method_block_result_called
                                                 ])
    end
  end
end
