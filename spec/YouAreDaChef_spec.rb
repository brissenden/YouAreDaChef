require 'spec_helper'

describe YouAreDaChef do
  DummyMathClass = Class.new do
    extend YouAreDaChef

    attr_reader :value

    def initialize(value)
      @value = value
    end

    def plus(x)
      @value =+ x
    end

    def substract(x)
      @value -= x
    end

    def multiply(x)
      @value = @value * x
    end

    def divide(x)
      @value = @value / x
    end
  end

  specify 'simple before / after hook' do
    klazz = DummyMathClass.dup
    instance = klazz.new(0)

    klazz.send(:before, :plus, proc { |x, object, other|
      expect(x).to eq 1
      expect(object).to eq instance
      expect(other).to be_nil
    })

    klazz.send(:after, :plus, proc { |x, object, result, other|
      expect(x).to eq 1
      expect(object).to eq instance
      expect(result).to eq 1
      expect(other).to be_nil
    })

    instance.plus(1)
    expect(instance.value).to eq 1
  end

  specify 'around hook' do
    klazz = DummyMathClass.dup
    instance = klazz.new(0)

    klazz.send(:around, :plus, proc { |method, args, object, other|
      expect(args).to eq [10, 20, 30]
      expect(object).to eq instance
      expect(other).to be_nil

      sum = args.inject(0){ |a, i| a += i }
      method.call(sum)
    })

    klazz.send(:around, :substract, proc { |method, args, object, other|
      expect(args).to eq [5, 10, 15]
      expect(object).to eq instance
      expect(other).to be_nil

      sum = args.inject(0){ |a, i| a += i }
      method.call(sum)
    })

    instance.plus(10, 20, 30)
    instance.substract(5, 10, 15)
    expect(instance.value).to eq 30
  end

  specify 'nested after hooks' do
    klazz = DummyMathClass.dup
    instance = klazz.new(0)

    klazz.send(:after, :plus, proc { |_, object|
      object.substract(4)
    })

    klazz.send(:after, :substract, proc { |_, object|
      object.multiply(2)
    })

    klazz.send(:after, :multiply, proc { |_, object|
      object.divide(4)
    })

    instance.plus(10)
    expect(instance.value).to eq 3
  end

  specify 'clear all callbacks' do
    klazz = DummyMathClass.dup
    instance = klazz.new(0)

    klazz.send(:before, :plus, proc {})
    klazz.send(:after, :plus, proc {})
    klazz.send(:around, :plus, proc {})

    expect(klazz.callbacks[:before][:plus].size).to eq 1
    expect(klazz.callbacks[:after][:plus].size).to eq 1
    expect(klazz.callbacks[:around][:plus].size).to eq 1
  end

  specify 'raises a proper error when two around callbacks are present' do
    klazz = DummyMathClass.dup
    instance = klazz.new(0)

    klazz.send(:around, :plus, proc { |method, args|
      method.call(*args)
    })

    klazz.send(:around, :plus, proc { |method, args|
      method.call(*args)
    })

    expect {
      instance.plus(2)
    }.to raise_error YouAreDaChef::MultipleAroundCallbacks, 'Only one around callback is allowed per method'
  end
end