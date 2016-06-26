[![Build Status](https://travis-ci.org/brissenden/YouAreDaChef.svg?branch=master)](https://travis-ci.org/brissenden/YouAreDaChef)
[![Code Climate](https://codeclimate.com/github/brissenden/YouAreDaChef/badges/gpa.svg)](https://codeclimate.com/github/brissenden/YouAreDaChef)
[![Test Coverage](https://codeclimate.com/github/brissenden/YouAreDaChef/badges/coverage.svg)](https://codeclimate.com/github/brissenden/YouAreDaChef/coverage)

# YouAreDaChef

A Ruby implementation of an YouAreDaChef library inspired by https://github.com/raganwald/YouAreDaChef.
This library supports `before`, `after` and `around` methods.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'YouAreDaChef'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install YouAreDaChef

## Usage

```
class Glue
  extend YouAreDaChef

  attr_reader :use_case

  def initialize
    @use_case = UseCase.new
  end

  def assigned
  end

  def assessed
  end

  around :assigned, proc { |method, args|
    method.call(*args)
    # some code
  }

  before :assessed, proc { |args, object|
    object.use_case.clean_up_old_assessments
    # some code
  }

  after :assessed, proc { |args, object, result|
    object.use_case.send_email_notification
    # some code
  }
end
```

After extening

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/brissenden/YouAreDaChef.