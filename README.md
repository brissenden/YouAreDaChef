[![Build Status](https://travis-ci.org/brissenden/YouAreDaChef.svg?branch=master)](https://travis-ci.org/brissenden/YouAreDaChef)
[![Maintainability](https://api.codeclimate.com/v1/badges/7f9576e4d3ebcb7e13b6/maintainability)](https://codeclimate.com/github/brissenden/YouAreDaChef/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7f9576e4d3ebcb7e13b6/test_coverage)](https://codeclimate.com/github/brissenden/YouAreDaChef/test_coverage)

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/brissenden/YouAreDaChef.
