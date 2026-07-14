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

    def parent_aspect_method
      methods_called << "parent_aspect_method"
      self
    end

    def child_aspect_parent_method
      methods_called << "child_aspect_parent_method"
      self
    end

    def parent_aspect_parent_method
      methods_called << "parent_aspect_parent_method"
      self
    end

    aspects :parent_aspect_child_method, before: :parent_aspect_method
    aspects :child_aspect_child_method, before: :child_aspect_method
  end

  class ChildClass < TestClass
    aspects :parent_aspect_parent_method, before: :parent_aspect_method
    aspects :child_aspect_parent_method, before: :child_aspect_method

    def child_aspect_method
      methods_called << "child_aspect_method"
      self
    end

    def parent_aspect_child_method
      methods_called << "parent_aspect_child_method"
      self
    end

    def child_aspect_child_method
      methods_called << "child_aspect_child_method"
      self
    end
  end

  describe 'aspects across inheritance' do
    describe 'aspects defined on the child' do
      describe 'aspect methods defined on the parent' do
        it 'can be used from the child class on parent class methods' do
          test_instance = ChildClass.new.parent_aspect_parent_method
          expect(test_instance.methods_called).to eq(%w{
            parent_aspect_method
            parent_aspect_parent_method
          })
        end

        it 'has no effect on parent class methods' do
          test_instance = TestClass.new.parent_aspect_parent_method
          expect(test_instance.methods_called).to eq(%w{
            parent_aspect_parent_method
          })
        end
      end

      describe 'aspect methods defined on the child' do
        it 'can be used from the child class on parent class methods' do
          test_instance = ChildClass.new.child_aspect_parent_method
          expect(test_instance.methods_called).to eq(%w{
            child_aspect_method
            child_aspect_parent_method
          })
        end

        it 'has no effect on parent class methods' do
          test_instance = TestClass.new.child_aspect_parent_method
          expect(test_instance.methods_called).to eq(%w{
            child_aspect_parent_method
          })
        end
      end
    end

    describe 'aspects defined on the parent' do
      describe 'aspect methods defined on the parent' do
        it 'can be used from the parent class on child class methods' do
          test_instance = ChildClass.new.parent_aspect_child_method
          expect(test_instance.methods_called).to eq(%w{
            parent_aspect_method
            parent_aspect_child_method
          })
        end

          it 'has no effect on parent class methods' do
          expect { TestClass.new.parent_aspect_child_method }.to raise_error(NoMethodError)
        end
      end

      describe 'aspect methods defined on the child' do
        it 'can be used from the parent class on child class methods' do
          test_instance = ChildClass.new.child_aspect_child_method
          expect(test_instance.methods_called).to eq(%w{
            child_aspect_method
            child_aspect_child_method
          })
        end

        it 'has no effect on parent class methods' do
          expect { TestClass.new.child_aspect_child_method }.to raise_error(NoMethodError)
        end
      end
    end
  end
end
