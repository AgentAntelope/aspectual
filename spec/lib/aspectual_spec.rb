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

    # These definitions could be looped over to make this class shorter, but the
    # decision has been made to go for clarity over brevity.
    def single_test_method
      methods_called << "single_test_method"
      self
    end

    def array_test_method_0
      methods_called << "array_test_method_0"
      self
    end

    def array_test_method_1
      methods_called << "array_test_method_1"
      self
    end

    def before_test_method_0
      methods_called << "before_test_method_0"
      self
    end

    def before_test_method_1
      methods_called << "before_test_method_1"
      self
    end

    def after_test_method_0
      methods_called << "after_test_method_0"
      self
    end

    def after_test_method_1
      methods_called << "after_test_method_1"
      self
    end

    def block_test_method_0
      methods_called << "before_block_test_method_0_block"
      yield
      methods_called << "after_block_test_method_0_block"
      self
    end

    def block_test_method_1
      methods_called << "before_block_test_method_1_block"
      yield
      methods_called << "after_block_test_method_1_block"
      self
    end

    aspects before: :single_test_method
    def single_before_test_method
      methods_called << "single_before_test_method"
      self
    end

    aspects around: :block_test_method_0
    def single_around_test_method
      methods_called << "single_around_test_method"
      self
    end

    aspects after: :single_test_method
    def single_after_test_method
      methods_called << "single_after_test_method"
      self
    end

    aspects before: [:array_test_method_0, :array_test_method_1]
    def array_before_test_method
      methods_called << "array_before_test_method"
      self
    end

    aspects around: [:block_test_method_0, :block_test_method_1]
    def array_around_test_method
      methods_called << "array_around_test_method"
      self
    end

    aspects after: [:array_test_method_0, :array_test_method_1]
    def array_after_test_method
      methods_called << "array_after_test_method"
      self
    end

    aspects before: [:before_test_method_0, :before_test_method_1], after: [:after_test_method_0, :after_test_method_1]
    def before_and_after_aspects_test_method
      methods_called << "before_and_after_aspects_test_method"
      self
    end

    def public_aspect_method
      methods_called << "public_aspect_method"
      self
    end

    protected
    aspects before: :public_aspect_method
    def protected_method
      methods_called << "protected_method"
      self
    end

    private
    aspects before: :public_aspect_method
    def private_method
      methods_called << "private_method"
      self
    end
  end

  describe "before aspects" do
    it "calls before aspect methods before the called method" do
      test_instance = TestClass.new.single_before_test_method
      expect(test_instance.methods_called).to eq(%w{
        single_test_method
        single_before_test_method
      })
    end

    it "allows multiple aspects to be declared" do
      test_instance = TestClass.new.array_before_test_method
      expect(test_instance.methods_called).to eq(%w{
        array_test_method_0
        array_test_method_1
        array_before_test_method
      })
    end
  end

  describe "after aspects" do
    it "calls before aspect methods before the called method" do
      test_instance = TestClass.new.single_after_test_method
      expect(test_instance.methods_called).to eq(%w{
        single_after_test_method
        single_test_method
      })
    end

    it "allows multiple aspects to be declared" do
      test_instance = TestClass.new.array_after_test_method
      expect(test_instance.methods_called).to eq(%w{
        array_after_test_method
        array_test_method_0
        array_test_method_1
      })
    end
  end

  describe "around aspects" do
    it "calls around aspect methods around the called method" do
      test_instance = TestClass.new.single_around_test_method
      expect(test_instance.methods_called).to eq(%w{
        before_block_test_method_0_block
        single_around_test_method
        after_block_test_method_0_block
      })
    end

    it "allows multiple aspects to be declared" do
      test_instance = TestClass.new.array_around_test_method
      expect(test_instance.methods_called).to eq(%w{
        before_block_test_method_0_block
        before_block_test_method_1_block
        array_around_test_method
        after_block_test_method_1_block
        after_block_test_method_0_block
      })
    end
  end

  describe "mixed aspects" do
    it "calls all the aspect declarations in the correct order" do
      test_instance = TestClass.new.before_and_after_aspects_test_method
      expect(test_instance.methods_called).to eq(%w{
        before_test_method_0
        before_test_method_1
        before_and_after_aspects_test_method
        after_test_method_0
        after_test_method_1
      })
    end
  end

  describe "public methods" do
    it "stay public" do
      test_instance = TestClass.new.single_before_test_method
      expect(test_instance.public_methods).to include(:single_before_test_method)
    end
  end

  describe "protected methods" do
    it "stay protected" do
      test_instance = TestClass.new
      expect(test_instance.protected_methods).to include(:protected_method)
    end
  end

  describe "private methods" do
    it "stay private" do
      test_instance = TestClass.new
      expect(test_instance.private_methods).to include(:private_method)
    end
  end
end
