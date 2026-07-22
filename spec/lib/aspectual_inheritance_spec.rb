# frozen_string_literal: true

require_relative '../../lib/aspectual'

class ParentClass
  extend Aspectual

  attr_reader :methods_called

  def initialize
    # This is to ensure that all methods are properly called within the
    # context of the current instance of this object.
    @methods_called = []
  end

  def parent_aspect_method
    methods_called << 'parent_aspect_method'
    self
  end

  def overridden_method
    methods_called << 'overridden_parent_method'
    self
  end

  def overridden_aspect_method
    methods_called << 'overridden_parent_aspect_method'
    self
  end

  def parent_aspect_parent_method_child_definition
    methods_called << 'parent_aspect_parent_method_child_definition'
    self
  end

  def parent_aspect_parent_method_super_child_definition
    methods_called << 'parent_aspect_parent_method_super_child_definition'
    self
  end

  def child_aspect_parent_method_parent_definition
    methods_called << 'child_aspect_parent_method_parent_definition'
    self
  end

  def child_aspect_parent_method_child_definition
    methods_called << 'child_aspect_parent_method_child_definition'
    self
  end

  def child_aspect_parent_method_super_child_definition
    methods_called << 'child_aspect_parent_method_super_child_definition'
    self
  end

  def super_child_aspect_parent_method_parent_definition
    methods_called << 'super_child_aspect_parent_method_parent_definition'
    self
  end

  def super_child_aspect_parent_method_child_definition
    methods_called << 'super_child_aspect_parent_method_child_definition'
    self
  end

  def super_child_aspect_parent_method_super_child_definition
    methods_called << 'super_child_aspect_parent_method_super_child_definition'
    self
  end

  aspects :parent_aspect_child_method_parent_definition, before: :parent_aspect_method
  aspects :parent_aspect_super_child_method_parent_definition, before: :parent_aspect_method
  aspects :child_aspect_parent_method_parent_definition, before: :child_aspect_method
  aspects :child_aspect_child_method_parent_definition, before: :child_aspect_method
  aspects :child_aspect_super_child_method_parent_definition, before: :child_aspect_method
  aspects :super_child_aspect_parent_method_parent_definition, before: :super_child_aspect_method
  aspects :super_child_aspect_child_method_parent_definition, before: :super_child_aspect_method
  aspects :super_child_aspect_super_child_method_parent_definition, before: :super_child_aspect_method
  aspects :overridden_method, before: :overridden_aspect_method
end

class ChildClass < ParentClass
  aspects :parent_aspect_parent_method_child_definition, before: :parent_aspect_method
  aspects :parent_aspect_child_method_child_definition, before: :parent_aspect_method
  aspects :parent_aspect_super_child_method_child_definition, before: :parent_aspect_method
  aspects :child_aspect_parent_method_child_definition, before: :child_aspect_method
  aspects :child_aspect_super_child_method_child_definition, before: :child_aspect_method
  aspects :super_child_aspect_parent_method_child_definition, before: :super_child_aspect_method
  aspects :super_child_aspect_child_method_child_definition, before: :super_child_aspect_method
  aspects :super_child_aspect_super_child_method_child_definition, before: :super_child_aspect_method

  def child_aspect_method
    methods_called << 'child_aspect_method'
    self
  end

  def overridden_method
    methods_called << 'overridden_child_method'
    self
  end

  def overridden_aspect_method
    methods_called << 'overridden_child_aspect_method'
    self
  end

  # The parent consumed the definition of the overridden aspect, so we need to
  # set it again.
  aspects :overridden_method, before: :overridden_aspect_method

  def parent_aspect_child_method_parent_definition
    methods_called << 'parent_aspect_child_method_parent_definition'
    self
  end

  def parent_aspect_child_method_child_definition
    methods_called << 'parent_aspect_child_method_child_definition'
    self
  end

  def parent_aspect_child_method_super_child_definition
    methods_called << 'parent_aspect_child_method_super_child_definition'
    self
  end

  def child_aspect_child_method_parent_definition
    methods_called << 'child_aspect_child_method_parent_definition'
    self
  end

  def child_aspect_child_method_super_child_definition
    methods_called << 'child_aspect_child_method_super_child_definition'
    self
  end

  def super_child_aspect_child_method_parent_definition
    methods_called << 'super_child_aspect_child_method_parent_definition'
    self
  end

  def super_child_aspect_child_method_child_definition
    methods_called << 'super_child_aspect_child_method_child_definition'
    self
  end

  def super_child_aspect_child_method_super_child_definition
    methods_called << 'super_child_aspect_child_method_super_child_definition'
    self
  end
end

class OtherChildClass < ParentClass
  aspects :parent_aspect_super_child_method_child_definition, before: :parent_aspect_method
  aspects :child_aspect_parent_method_child_definition, before: :child_aspect_method
  aspects :child_aspect_super_child_method_child_definition, before: :child_aspect_method
  aspects :super_child_aspect_parent_method_child_definition, before: :super_child_aspect_method
  aspects :super_child_aspect_child_method_child_definition, before: :super_child_aspect_method
  aspects :super_child_aspect_super_child_method_child_definition, before: :super_child_aspect_method

  def child_aspect_method
    methods_called << 'other_child_aspect_method'
    self
  end

  def overridden_method
    methods_called << 'overridden_other_child_method'
    self
  end

  # The parent consumed the definition of the overridden aspect, so we need to
  # set it again.
  aspects :overridden_method, before: :overridden_aspect_method

  def overridden_aspect_method
    methods_called << 'overridden_other_child_aspect_method'
    self
  end

  def parent_aspect_child_method_parent_definition
    methods_called << 'parent_aspect_other_child_method_parent_definition'
    self
  end

  def parent_aspect_child_method_child_definition
    methods_called << 'parent_aspect_other_child_method_other_child_definition'
    self
  end

  def parent_aspect_child_method_super_child_definition
    methods_called << 'parent_aspect_other_child_method_super_child_definition'
    self
  end

  def child_aspect_child_method_parent_definition
    methods_called << 'child_aspect_other_child_method_parent_definition'
    self
  end

  def child_aspect_child_method_super_child_definition
    methods_called << 'child_aspect_other_child_method_super_child_definition'
    self
  end

  def super_child_aspect_child_method_parent_definition
    methods_called << 'super_child_aspect_other_child_method_parent_definition'
    self
  end

  def super_child_aspect_child_method_child_definition
    methods_called << 'super_child_aspect_other_child_method_other_child_definition'
    self
  end

  def super_child_aspect_child_method_super_child_definition
    methods_called << 'super_child_aspect_other_child_method_super_child_definition'
    self
  end
end

class SuperChildClass < ChildClass
  aspects :parent_aspect_parent_method_super_child_definition, before: :parent_aspect_method
  aspects :parent_aspect_child_method_super_child_definition, before: :parent_aspect_method
  aspects :parent_aspect_super_child_method_super_child_definition, before: :parent_aspect_method
  aspects :child_aspect_parent_method_super_child_definition, before: :child_aspect_method
  aspects :child_aspect_child_method_super_child_definition, before: :child_aspect_method
  aspects :child_aspect_super_child_method_super_child_definition, before: :child_aspect_method
  aspects :super_child_aspect_parent_method_super_child_definition, before: :super_child_aspect_method
  aspects :super_child_aspect_child_method_super_child_definition, before: :super_child_aspect_method

  def super_child_aspect_method
    methods_called << 'super_child_aspect_method'
    self
  end

  def overridden_method
    methods_called << 'overridden_super_child_method'
    self
  end

  def overridden_aspect_method
    methods_called << 'overridden_super_child_aspect_method'
    self
  end

  # The parent consumed the definition of the overridden aspect, so we need to
  # set it again.
  aspects :overridden_method, before: :overridden_aspect_method

  def parent_aspect_super_child_method_parent_definition
    methods_called << 'parent_aspect_super_child_method_parent_definition'
    self
  end

  def parent_aspect_super_child_method_child_definition
    methods_called << 'parent_aspect_super_child_method_child_definition'
    self
  end

  def parent_aspect_super_child_method_super_child_definition
    methods_called << 'parent_aspect_super_child_method_super_child_definition'
    self
  end

  def child_aspect_super_child_method_parent_definition
    methods_called << 'child_aspect_super_child_method_parent_definition'
    self
  end

  def child_aspect_super_child_method_child_definition
    methods_called << 'child_aspect_super_child_method_child_definition'
    self
  end

  def child_aspect_super_child_method_super_child_definition
    methods_called << 'child_aspect_super_child_method_super_child_definition'
    self
  end

  def super_child_aspect_super_child_method_parent_definition
    methods_called << 'super_child_aspect_super_child_method_parent_definition'
    self
  end

  def super_child_aspect_super_child_method_child_definition
    methods_called << 'super_child_aspect_super_child_method_child_definition'
    self
  end
end

describe Aspectual do
  describe 'aspects across inheritance' do
    describe 'methods defined on the parent' do
      it 'is unaffected when overridden by descendants' do
        result = ParentClass.new.overridden_method

        expect(result.methods_called).to eq(
          %w[
            overridden_parent_aspect_method
            overridden_parent_method
          ],
        )
      end

      describe 'can have aspects from a parent defined on the child' do
        it 'does not affect the parent class' do
          result = ParentClass.new.parent_aspect_parent_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_parent_method_child_definition
            ],
          )
        end

        it 'does affect the child class' do
          result = ChildClass.new.parent_aspect_parent_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_method
              parent_aspect_parent_method_child_definition
            ],
          )
        end

        it 'does not affect the other child class' do
          result = OtherChildClass.new.parent_aspect_parent_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_parent_method_child_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.parent_aspect_parent_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_method
              parent_aspect_parent_method_child_definition
            ],
          )
        end
      end

      describe 'can have aspects from a parent defined on the super child' do
        it 'does not affect the parent class' do
          result = ParentClass.new.parent_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_parent_method_super_child_definition
            ],
          )
        end

        it 'does not affect the child class' do
          result = ChildClass.new.parent_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_parent_method_super_child_definition
            ],
          )
        end

        it 'does not affect the other child class' do
          result = OtherChildClass.new.parent_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_parent_method_super_child_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.parent_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_method
              parent_aspect_parent_method_super_child_definition
            ],
          )
        end
      end

      describe 'can have aspects from a child defined on the parent' do
        it 'does not affect the parent class' do
          # The specified aspect is not defined on the parent class
          expect do
            ParentClass.new.child_aspect_parent_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does affect the child class' do
          result = ChildClass.new.child_aspect_parent_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_method
              child_aspect_parent_method_parent_definition
            ],
          )
        end

        it 'does affect the other child class' do
          result = OtherChildClass.new.child_aspect_parent_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              other_child_aspect_method
              child_aspect_parent_method_parent_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.child_aspect_parent_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_method
              child_aspect_parent_method_parent_definition
            ],
          )
        end
      end

      describe 'can have aspects from a child defined on the child' do
        it 'does not affect the parent class' do
          result = ParentClass.new.child_aspect_parent_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_parent_method_child_definition
            ],
          )
        end

        it 'does affect the child class' do
          result = ChildClass.new.child_aspect_parent_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_method
              child_aspect_parent_method_child_definition
            ],
          )
        end

        it 'does affect the other child class' do
          result = OtherChildClass.new.child_aspect_parent_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              other_child_aspect_method
              child_aspect_parent_method_child_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.child_aspect_parent_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_method
              child_aspect_parent_method_child_definition
            ],
          )
        end
      end

      describe 'can have aspects from a child defined on the super child' do
        it 'does not affect the parent class' do
          result = ParentClass.new.child_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_parent_method_super_child_definition
            ],
          )
        end

        it 'does not affect the child class' do
          result = ChildClass.new.child_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_parent_method_super_child_definition
            ],
          )
        end

        it 'does not affect the other child class' do
          result = OtherChildClass.new.child_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_parent_method_super_child_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.child_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_method
              child_aspect_parent_method_super_child_definition
            ],
          )
        end
      end

      describe 'can have aspects from a super child defined on the parent' do
        it 'does not affect the parent class' do
          # The specified aspect is not defined on the parent class
          expect do
            ParentClass.new.super_child_aspect_parent_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the child class' do
          # The specified aspect is not defined on the child class
          expect do
            ChildClass.new.super_child_aspect_parent_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the other child class' do
          # The specified aspect is not defined on the other child class
          expect do
            ChildClass.new.super_child_aspect_parent_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.super_child_aspect_parent_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              super_child_aspect_method
              super_child_aspect_parent_method_parent_definition
            ],
          )
        end
      end

      describe 'can have aspects from a super child defined on the child' do
        it 'does not affect the parent class' do
          result = ParentClass.new.super_child_aspect_parent_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              super_child_aspect_parent_method_child_definition
            ],
          )
        end

        it 'does not affect the child class' do
          # The specified aspect is not defined on the child class
          expect do
            ChildClass.new.super_child_aspect_parent_method_child_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the other child class' do
          # The specified aspect is not defined on the other child class
          expect do
            ChildClass.new.super_child_aspect_parent_method_child_definition
          end.to raise_error(NoMethodError)
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.super_child_aspect_parent_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              super_child_aspect_method
              super_child_aspect_parent_method_child_definition
            ],
          )
        end
      end

      describe 'can have aspects from a super child defined on the super child' do
        it 'does not affect the parent class' do
          result = ParentClass.new.super_child_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              super_child_aspect_parent_method_super_child_definition
            ],
          )
        end

        it 'does not affect the child class' do
          result = ChildClass.new.super_child_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              super_child_aspect_parent_method_super_child_definition
            ],
          )
        end

        it 'does not affect the other child class' do
          result = OtherChildClass.new.super_child_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              super_child_aspect_parent_method_super_child_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.super_child_aspect_parent_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              super_child_aspect_method
              super_child_aspect_parent_method_super_child_definition
            ],
          )
        end
      end
    end

    describe 'methods defined on the child' do
      it 'can override parent definitions' do
        result = ChildClass.new.overridden_method

        expect(result.methods_called).to eq(
          %w[
            overridden_child_aspect_method
            overridden_child_method
          ],
        )
      end

      describe 'can have aspects from the parent defined on the parent' do
        it 'does not affect the parent class' do
          # The specified method is not defined on the parent class
          expect do
            ParentClass.new.parent_aspect_child_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does affect the child class' do
          result = ChildClass.new.parent_aspect_child_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_method
              parent_aspect_child_method_parent_definition
            ],
          )
        end

        it 'does affect the other child class' do
          result = OtherChildClass.new.parent_aspect_child_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_method
              parent_aspect_other_child_method_parent_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.parent_aspect_child_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_method
              parent_aspect_child_method_parent_definition
            ],
          )
        end
      end

      describe 'can have aspects from the parent defined on the child' do
        it 'does not affect the parent class' do
          # The specified method is not defined on the parent class
          expect do
            ParentClass.new.parent_aspect_child_method_child_definition
          end.to raise_error(NoMethodError)
        end

        it 'does affect the child class' do
          result = ChildClass.new.parent_aspect_child_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_method
              parent_aspect_child_method_child_definition
            ],
          )
        end

        it 'does not affect the other child class' do
          result = OtherChildClass.new.parent_aspect_child_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_other_child_method_other_child_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.parent_aspect_child_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_method
              parent_aspect_child_method_child_definition
            ],
          )
        end
      end

      describe 'can have aspects from the parent defined on the super child' do
        it 'does not affect the parent class' do
          # The specified method is not defined on the parent class
          expect do
            ParentClass.new.parent_aspect_child_method_super_child_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the child class' do
          result = ChildClass.new.parent_aspect_child_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_child_method_super_child_definition
            ],
          )
        end

        it 'does not affect the other child class' do
          result = OtherChildClass.new.parent_aspect_child_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_other_child_method_super_child_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.parent_aspect_child_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_method
              parent_aspect_child_method_super_child_definition
            ],
          )
        end
      end

      describe 'can have aspects from the child defined on the parent' do
        it 'does not affect the parent class' do
          # The specified method is not defined on the parent class
          expect do
            ParentClass.new.child_aspect_child_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does affect the child class' do
          result = ChildClass.new.child_aspect_child_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_method
              child_aspect_child_method_parent_definition
            ],
          )
        end

        it 'does affect the other child class' do
          result = OtherChildClass.new.child_aspect_child_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              other_child_aspect_method
              child_aspect_other_child_method_parent_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.child_aspect_child_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_method
              child_aspect_child_method_parent_definition
            ],
          )
        end
      end

      describe 'can have aspects from the child defined on the super child' do
        it 'does not affect the parent class' do
          # The specified method is not defined on the parent class
          expect do
            ParentClass.new.child_aspect_child_method_super_child_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the child class' do
          result = ChildClass.new.child_aspect_child_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_child_method_super_child_definition
            ],
          )
        end

        it 'does affect the other child class' do
          result = OtherChildClass.new.child_aspect_child_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_other_child_method_super_child_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.child_aspect_child_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_method
              child_aspect_child_method_super_child_definition
            ],
          )
        end
      end

      describe 'can have aspects from the super child defined on the parent' do
        it 'does not affect the parent class' do
          # The specified method is not defined on the parent class
          expect do
            ParentClass.new.super_child_aspect_child_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the child class' do
          # The specified aspect is not defined on the child class
          expect do
            ChildClass.new.super_child_aspect_child_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the other child class' do
          # The specified aspect is not defined on the other child class
          expect do
            OtherChildClass.new.super_child_aspect_child_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.super_child_aspect_child_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              super_child_aspect_method
              super_child_aspect_child_method_parent_definition
            ],
          )
        end
      end

      describe 'can have aspects from the super child defined on the child' do
        it 'does not affect the parent class' do
          # The specified method is not defined on the parent class
          expect do
            ParentClass.new.super_child_aspect_child_method_child_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the child class' do
          # The specified aspect is not defined on the child class
          expect do
            ChildClass.new.super_child_aspect_child_method_child_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the other child class' do
          # The specified aspect is not defined on the other child class
          expect do
            OtherChildClass.new.super_child_aspect_child_method_child_definition
          end.to raise_error(NoMethodError)
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.super_child_aspect_child_method_child_definition

          expect(result.methods_called).to eq(
            %w[
              super_child_aspect_method
              super_child_aspect_child_method_child_definition
            ],
          )
        end
      end

      describe 'can have aspects from the super child defined on the super child' do
        it 'does not affect the parent class' do
          # The specified method is not defined on the parent class
          expect do
            ParentClass.new.super_child_aspect_child_method_super_child_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the child class' do
          result = ChildClass.new.child_aspect_child_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_child_method_super_child_definition
            ],
          )
        end

        it 'does not affect the other child class' do
          result = OtherChildClass.new.child_aspect_child_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              child_aspect_other_child_method_super_child_definition
            ],
          )
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.super_child_aspect_child_method_super_child_definition

          expect(result.methods_called).to eq(
            %w[
              super_child_aspect_method
              super_child_aspect_child_method_super_child_definition
            ],
          )
        end
      end
    end

    describe 'methods defined on the super child' do
      it 'can override parent definitions' do
        result = SuperChildClass.new.overridden_method

        expect(result.methods_called).to eq(
          %w[
            overridden_super_child_aspect_method
            overridden_super_child_method
          ],
        )
      end

      describe 'can have aspects from the parent defined on the parent' do
        it 'does not affect the parent class' do
          # The specified method is not defined on the parent class
          expect do
            ParentClass.new.parent_aspect_super_child_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the child class' do
          # The specified method is not defined on the child class
          expect do
            ChildClass.new.parent_aspect_super_child_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does not affect the other child class' do
          # The specified method is not defined on the other child class
          expect do
            OtherChildClass.new.parent_aspect_super_child_method_parent_definition
          end.to raise_error(NoMethodError)
        end

        it 'does affect the super child class' do
          result = SuperChildClass.new.parent_aspect_super_child_method_parent_definition

          expect(result.methods_called).to eq(
            %w[
              parent_aspect_method
              parent_aspect_super_child_method_parent_definition
            ],
          )
        end
      end
    end

    describe 'can have aspects from the parent defined on the child' do
      it 'does not affect the parent class' do
        # The specified method is not defined on the parent class
        expect do
          ParentClass.new.parent_aspect_super_child_method_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the child class' do
        # The specified method is not defined on the child class
        expect do
          ChildClass.new.parent_aspect_super_child_method_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the other child class' do
        # The specified method is not defined on the other child class
        expect do
          OtherChildClass.new.parent_aspect_super_child_method_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does affect the super child class' do
        result = SuperChildClass.new.parent_aspect_super_child_method_child_definition

        expect(result.methods_called).to eq(
          %w[
            parent_aspect_method
            parent_aspect_super_child_method_child_definition
          ],
        )
      end
    end

    describe 'can have aspects from the parent defined on the super child' do
      it 'does not affect the parent class' do
        # The specified method is not defined on the parent class
        expect do
          ParentClass.new.parent_aspect_super_child_method_super_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the child class' do
        # The specified method is not defined on the child class
        expect do
          ChildClass.new.parent_aspect_super_child_method_super_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the other child class' do
        # The specified method is not defined on the other child class
        expect do
          OtherChildClass.new.parent_aspect_super_child_method_super_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does affect the super child class' do
        result = SuperChildClass.new.parent_aspect_super_child_method_super_child_definition

        expect(result.methods_called).to eq(
          %w[
            parent_aspect_method
            parent_aspect_super_child_method_super_child_definition
          ],
        )
      end
    end

    describe 'can have aspects from the child defined on the parent' do
      it 'does not affect the parent class' do
        # The specified method is not defined on the parent class
        expect do
          ParentClass.new.child_aspect_super_child_method_parent_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the child class' do
        # The specified method is not defined on the child class
        expect do
          ChildClass.new.child_aspect_super_child_method_parent_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the other child class' do
        # The specified method is not defined on the other child class
        expect do
          OtherChildClass.new.child_aspect_super_child_method_parent_definition
        end.to raise_error(NoMethodError)
      end

      it 'does affect the super child class' do
        result = SuperChildClass.new.child_aspect_super_child_method_parent_definition

        expect(result.methods_called).to eq(
          %w[
            child_aspect_method
            child_aspect_super_child_method_parent_definition
          ],
        )
      end
    end

    describe 'can have aspects from the child defined on the child' do
      it 'does not affect the parent class' do
        # The specified method is not defined on the parent class
        expect do
          ParentClass.new.child_aspect_super_child_method_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the child class' do
        # The specified method is not defined on the child class
        expect do
          ChildClass.new.child_aspect_super_child_method_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the other child class' do
        # The specified method is not defined on the other child class
        expect do
          OtherChildClass.new.child_aspect_super_child_method_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does affect the super child class' do
        result = SuperChildClass.new.child_aspect_super_child_method_child_definition

        expect(result.methods_called).to eq(
          %w[
            child_aspect_method
            child_aspect_super_child_method_child_definition
          ],
        )
      end
    end

    describe 'can have aspects from the child defined on the super child' do
      it 'does not affect the parent class' do
        # The specified method is not defined on the parent class
        expect do
          ParentClass.new.child_aspect_super_child_method_super_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the child class' do
        # The specified method is not defined on the child class
        expect do
          ChildClass.new.child_aspect_super_child_method_super_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the other child class' do
        # The specified method is not defined on the other child class
        expect do
          OtherChildClass.new.child_aspect_super_child_method_super_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does affect the super child class' do
        result = SuperChildClass.new.child_aspect_super_child_method_super_child_definition

        expect(result.methods_called).to eq(
          %w[
            child_aspect_method
            child_aspect_super_child_method_super_child_definition
          ],
        )
      end
    end

    describe 'can have aspects from the super child defined on the parent' do
      it 'does not affect the parent class' do
        # The specified method is not defined on the parent class
        expect do
          ParentClass.new.super_child_aspect_super_child_method_parent_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the child class' do
        # The specified method is not defined on the child class
        expect do
          ChildClass.new.super_child_aspect_super_child_method_parent_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the other child class' do
        # The specified method is not defined on the other child class
        expect do
          OtherChildClass.new.super_child_aspect_super_child_method_parent_definition
        end.to raise_error(NoMethodError)
      end

      it 'does affect the super child class' do
        result = SuperChildClass.new.super_child_aspect_super_child_method_parent_definition

        expect(result.methods_called).to eq(
          %w[
            super_child_aspect_method
            super_child_aspect_super_child_method_parent_definition
          ],
        )
      end
    end

    describe 'can have aspects from the super child defined on the child' do
      it 'does not affect the parent class' do
        # The specified method is not defined on the parent class
        expect do
          ParentClass.new.super_child_aspect_super_child_method_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the child class' do
        # The specified method is not defined on the child class
        expect do
          ChildClass.new.super_child_aspect_super_child_method_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does not affect the other child class' do
        # The specified method is not defined on the other child class
        expect do
          OtherChildClass.new.super_child_aspect_super_child_method_child_definition
        end.to raise_error(NoMethodError)
      end

      it 'does affect the super child class' do
        result = SuperChildClass.new.super_child_aspect_super_child_method_child_definition

        expect(result.methods_called).to eq(
          %w[
            super_child_aspect_method
            super_child_aspect_super_child_method_child_definition
          ],
        )
      end
    end
  end
end
