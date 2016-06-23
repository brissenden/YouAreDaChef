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

    klazz.send(:before, :plus, proc { |x, other|
      expect(x).to eq 1
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
end