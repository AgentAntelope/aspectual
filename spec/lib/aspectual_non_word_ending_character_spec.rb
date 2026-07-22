# frozen_string_literal: true

require_relative '../../lib/aspectual'

class NonWordEndingCharacterTestClass
  extend Aspectual

  attr_reader :methods_called

  def initialize
    # This is to ensure that all methods are properly called within the
    # context of the current instance of this object.
    @methods_called = []
  end

  def predicate_aspect_method?
    methods_called << 'predicate_aspect_method?'
    self
  end

  aspects before: :predicate_aspect_method?
  def predicate_test_method
    methods_called << 'predicate_test_method'
    self
  end

  aspects before: :predicate_aspect_method?
  def predicate_test_method?
    methods_called << 'predicate_test_method?'
    self
  end

  def bang_aspect_method!
    methods_called << 'bang_aspect_method!'
    self
  end

  aspects before: :bang_aspect_method!
  def bang_test_method
    methods_called << 'bang_test_method'
    self
  end

  aspects before: :bang_aspect_method!
  def bang_test_method!
    methods_called << 'bang_test_method!'
    self
  end

  def assign_aspect_method=
    methods_called << 'assign_aspect_method='
  end

  aspects before: :assign_aspect_method=
  def assign_test_method
    methods_called << 'assign_test_method'
    self
  end

  aspects before: :assign_aspect_method=
  def assign_test_method=
    methods_called << 'assign_test_method='
  end
end

describe Aspectual do
  describe 'methods ending in non-standard characters' do
    describe 'predicate methods' do
      it 'can handle predicate aspects' do
        test_instance = NonWordEndingCharacterTestClass.new
        test_instance.predicate_test_method
        expect(test_instance.methods_called).to eq(%w[
                                                     predicate_aspect_method?
                                                     predicate_test_method
                                                   ])
      end

      it 'can handle predicate methods' do
        test_instance = NonWordEndingCharacterTestClass.new
        test_instance.predicate_test_method?
        expect(test_instance.methods_called).to eq(%w[
                                                     predicate_aspect_method?
                                                     predicate_test_method?
                                                   ])
      end
    end

    describe 'bang methods' do
      it 'can handle bang aspects' do
        test_instance = NonWordEndingCharacterTestClass.new
        test_instance.bang_test_method
        expect(test_instance.methods_called).to eq(%w[
                                                     bang_aspect_method!
                                                     bang_test_method
                                                   ])
      end

      it 'can handle bang methods' do
        test_instance = NonWordEndingCharacterTestClass.new
        test_instance.bang_test_method!
        expect(test_instance.methods_called).to eq(%w[
                                                     bang_aspect_method!
                                                     bang_test_method!
                                                   ])
      end
    end

    describe 'assign methods' do
      it 'can handle assign aspects' do
        test_instance = NonWordEndingCharacterTestClass.new
        test_instance.assign_test_method
        expect(test_instance.methods_called).to eq(%w[
                                                     assign_aspect_method=
                                                     assign_test_method
                                                   ])
      end

      it 'can handle assign methods' do
        test_instance = NonWordEndingCharacterTestClass.new
        test_instance.send(:assign_test_method=)
        expect(test_instance.methods_called).to eq(%w[
                                                     assign_aspect_method=
                                                     assign_test_method=
                                                   ])
      end
    end
  end
end
