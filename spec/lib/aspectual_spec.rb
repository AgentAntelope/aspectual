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

    # TODO: Add test methods demonstrating all parameter forwarding

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

    def predicate_aspect_method?
      methods_called << "predicate_aspect_method?"
      self
    end

    aspects before: :predicate_aspect_method?
    def predicate_test_method
      methods_called << "predicate_test_method"
      self
    end

    aspects before: :predicate_aspect_method?
    def predicate_test_method?
      methods_called << "predicate_test_method?"
      self
    end

    def bang_aspect_method!
      methods_called << "bang_aspect_method!"
      self
    end

    aspects before: :bang_aspect_method!
    def bang_test_method
      methods_called << "bang_test_method"
      self
    end

    aspects before: :bang_aspect_method!
    def bang_test_method!
      methods_called << "bang_test_method!"
      self
    end

    def assign_aspect_method=
      methods_called << "assign_aspect_method="
      self
    end

    aspects before: :assign_aspect_method=
    def assign_test_method
      methods_called << "assign_test_method"
      self
    end

    aspects before: :assign_aspect_method=
    def assign_test_method=
      methods_called << "assign_test_method="
      self
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

    def block_aspect_method(&block)
      methods_called << "block_aspect_method_block_result_#{block.call}"
      self
    end

    def block_around_aspect_method(&block)
      methods_called << "before_block_block_around_aspect_method_block"
      block.call
      methods_called << "after_block_block_around_aspect_method_block"
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

  describe "methods ending in non-standard characters" do
    describe "predicate methods" do
      it 'can handle predicate aspects' do
        test_instance = TestClass.new.predicate_test_method
        expect(test_instance.methods_called).to eq(%w{
          predicate_aspect_method?
          predicate_test_method
        })
      end

      it 'can handle predicate methods' do
        test_instance = TestClass.new.predicate_test_method?
        expect(test_instance.methods_called).to eq(%w{
          predicate_aspect_method?
          predicate_test_method?
        })
      end
    end

    describe "bang methods" do
      it 'can handle bang aspects' do
        test_instance = TestClass.new.bang_test_method
        expect(test_instance.methods_called).to eq(%w{
          bang_aspect_method!
          bang_test_method
        })
      end

      it 'can handle bang methods' do
        test_instance = TestClass.new.bang_test_method!
        expect(test_instance.methods_called).to eq(%w{
          bang_aspect_method!
          bang_test_method!
        })
      end
    end

    describe "assign methods" do
      it 'can handle assign aspects' do
        test_instance = TestClass.new.assign_test_method
        expect(test_instance.methods_called).to eq(%w{
          assign_aspect_method=
          assign_test_method
        })
      end

      it 'can handle assign methods' do
        test_instance = TestClass.new.send(:assign_test_method=)
        expect(test_instance.methods_called).to eq(%w{
          assign_aspect_method=
          assign_test_method=
        })
      end
    end
  end

  describe "methods with positional arguments" do
    it 'can handle before aspects' do
      test_instance = TestClass.new.before_positional_test_method("arg_1", "arg_2")
        expect(test_instance.methods_called).to eq(%w{
          positional_aspect_method_args_arg_1_arg_2
          before_positional_test_method_args_arg_1_arg_2
        })
    end

    it 'can handle around aspects' do
      test_instance = TestClass.new.around_positional_test_method("arg_1", "arg_2")
        expect(test_instance.methods_called).to eq(%w{
          before_block_positional_around_aspect_method_args_arg_1_arg_2
          before_positional_test_method_args_arg_1_arg_2
          after_block_positional_around_aspect_method_args_arg_1_arg_2
        })
    end

    it 'can handle after aspects' do
      test_instance = TestClass.new.after_positional_test_method("arg_1", "arg_2")
        expect(test_instance.methods_called).to eq(%w{
          after_positional_test_method_args_arg_1_arg_2
          positional_aspect_method_args_arg_1_arg_2
        })
    end
  end

  describe "methods with kwarg arguments" do
    it 'can handle before aspects' do
      test_instance = TestClass.new.before_kwarg_test_method(kwarg_1: :val_1, kwarg_2: :val_2)
        expect(test_instance.methods_called).to eq(%w{
          kwarg_aspect_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
          before_kwarg_test_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
        })
    end

    it 'can handle around aspects' do
      test_instance = TestClass.new.around_kwarg_test_method(kwarg_1: :val_1, kwarg_2: :val_2)
        expect(test_instance.methods_called).to eq(%w{
          before_block_kwarg_around_aspect_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
          around_kwarg_test_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
          after_block_kwarg_around_aspect_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
        })
    end

    it 'can handle after aspects' do
      test_instance = TestClass.new.after_kwarg_test_method(kwarg_1: :val_1, kwarg_2: :val_2)
        expect(test_instance.methods_called).to eq(%w{
          after_kwarg_test_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
          kwarg_aspect_method_kwargs_kwarg_1_val_1_kwarg_2_val_2
        })
    end
  end

  describe "methods with block arguments" do
    it 'can handle before aspects' do
      test_instance = TestClass.new.before_block_test_method { "called" }
        expect(test_instance.methods_called).to eq(%w{
          block_aspect_method_block_result_called
          before_block_test_method_block_result_called
        })
    end

    it 'can handle around aspects' do
      test_instance = TestClass.new.around_block_test_method { "called" }
        expect(test_instance.methods_called).to eq(%w{
          before_block_block_around_aspect_method_block
          around_block_test_method_block_result_called
          after_block_block_around_aspect_method_block
        })
    end

    it 'can handle after aspects' do
      test_instance = TestClass.new.after_block_test_method { "called" }
        expect(test_instance.methods_called).to eq(%w{
          after_block_test_method_block_result_called
          block_aspect_method_block_result_called
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
