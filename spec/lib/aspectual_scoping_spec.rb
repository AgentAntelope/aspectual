# frozen_string_literal: true

require_relative '../../lib/aspectual'

class ScopingTestClass
  extend Aspectual

  attr_reader :methods_called

  def initialize
    # This is to ensure that all methods are properly called within the
    # context of the current instance of this object.
    @methods_called = []
  end

  def public_aspect_method
    methods_called << 'public_aspect_method'
    self
  end

  aspects before: %i[
    public_aspect_method
    protected_aspect_method
    private_aspect_method
  ]

  def public_method
    methods_called << 'public_method'
    self
  end

  aspects before: :protected_aspect_method
  def test_protected_aspect_method
    methods_called << 'protected_test_method'
    self
  end

  aspects before: :private_aspect_method
  def test_private_aspect_method
    methods_called << 'private_test_method'
    self
  end

  protected

  def protected_aspect_method
    methods_called << 'protected_aspect_method'
    self
  end

  aspects before: %i[
    public_aspect_method
    protected_aspect_method
    private_aspect_method
  ]

  def protected_method
    methods_called << 'protected_method'
    self
  end

  private

  def private_aspect_method
    methods_called << 'private_aspect_method'
    self
  end

  aspects before: %i[
    public_aspect_method
    protected_aspect_method
    private_aspect_method
  ]

  def private_method
    methods_called << 'private_method'
    self
  end
end

describe Aspectual do
  describe 'public methods' do
    it 'can have varying accessibility aspects' do
      test_instance = ScopingTestClass.new.public_method
      expect(test_instance.methods_called).to eq(%w[
                                                   public_aspect_method
                                                   protected_aspect_method
                                                   private_aspect_method
                                                   public_method
                                                 ])
    end

    it 'stays public' do
      test_instance = ScopingTestClass.new
      expect(test_instance.public_methods).to include(:public_method)
    end
  end

  describe 'protected methods' do
    it 'can have varying accessibility aspects' do
      test_instance = ScopingTestClass.new.send(:protected_method)
      expect(test_instance.methods_called).to eq(%w[
                                                   public_aspect_method
                                                   protected_aspect_method
                                                   private_aspect_method
                                                   protected_method
                                                 ])
    end

    it 'stays protected' do
      test_instance = ScopingTestClass.new
      expect(test_instance.protected_methods).to include(:protected_method)
    end
  end

  describe 'private methods' do
    it 'can have varying accessibility aspects' do
      test_instance = ScopingTestClass.new.send(:private_method)
      expect(test_instance.methods_called).to eq(%w[
                                                   public_aspect_method
                                                   protected_aspect_method
                                                   private_aspect_method
                                                   private_method
                                                 ])
    end

    it 'stays private' do
      test_instance = ScopingTestClass.new
      expect(test_instance.private_methods).to include(:private_method)
    end
  end
end
