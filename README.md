[![Gem Version](https://badge.fury.io/rb/aspectual.png)](http://badge.fury.io/rb/aspectual)

# Aspectual

A simple gem to support minimal Aspect Oriented Programming in ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'aspectual'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aspectual

## Usage

Extend the module

    extend Aspectual

Create any methods you want as aspects (Aspectual will not add methods you don't have as aspects)

Then declare your aspects

    aspects before: :logging, around: fancy_logging, after: :more_logging
    def foo
      "foo"
    end

    aspects before: [:notify_user, :notify_admin], around: [:setup_and_teardown, :play_background_music], after: [:remove_temp_files, :play_sound]
    def bar
      "bar"
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
