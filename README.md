[![Gem Version](https://badge.fury.io/rb/aspectual.png)](http://badge.fury.io/rb/aspectual)

# Aspectual

A simple gem to support minimal Aspect Oriented Programming in ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'aspectual'

And then execute:

    bundle install

Or install it yourself as:

    gem install aspectual

## Usage

Extend the module

    extend Aspectual

### Implicit method aspects

Aspectual supports implicitly defining your aspects directly before a method.
This method of defining aspects will hook into the next defined method,
assigning those aspects to that method:

    aspects before: :logging, around: fancy_logging, after: :more_logging
    def foo
      "foo"
    end

    aspects before: [:notify_user, :notify_admin], around: [:setup_and_teardown, :play_background_music], after: [:remove_temp_files, :play_sound]
    def bar
      "bar"
    end

### Explicit method aspects

Aspectual supports defining your aspects associated with a specific method,
which will be added either immediately (if the method is defined) or when that
method is first defined on the associated class.

    def foo
      "foo"
    end

    aspects :foo, before: :logging, around: fancy_logging, after: :more_logging

    aspects :bar, before: [:notify_user, :notify_admin], around: [:setup_and_teardown, :play_background_music], after: [:remove_temp_files, :play_sound]

    def bar
      "bar"
    end

### Inheriting aspects

Aspectual supports defining aspects in a parent class, when those methods will
be defined in a child class. Aspectual will attach the aspects to the next
definition of the named method, to support child classes inheriting aspected
behaviors.

    class Foo
      aspects :foo, before: :logging, around: fancy_logging, after: :more_logging
    end

    class Bar < Foo
      def foo
        "foo"
      end
    end

This behavior means that defining an aspect on an interface that is implemented
will require a call to `super` to invoke those aspects:

    class Foo
      aspects :foo, before: :logging, around: fancy_logging, after: :more_logging
      def foo
        "foo"
      end
    end

    class Bar < Foo
      def foo
        super + "bar"
      end
    end

    class Baz < Foo
      # Does not call aspects defined in Foo
      def foo
        "baz"
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
