require 'YouAreDaChef/version'
require 'securerandom'

module YouAreDaChef
  CallbackNotDefined = Class.new(StandardError)
  MultipleAroundCallbacks = Class.new(StandardError)

  def callbacks
    @callbacks ||= default_callbacks
  end

  def before(method, callback)
    define_callback(:before, method, callback)
  end

  def after(method, callback)
    define_callback(:after, method, callback)
  end

  def around(method, callback)
    define_callback(:around, method, callback)
  end

  def remove_all_callbacks
    @callbacks = default_callbacks
  end

  private
  def default_callbacks
    { before: {}, after: {}, around: {} }
  end

  def filter_callbacks(type, method)
    callbacks[type][method] || []
  end

  def define_callback(type, method, block)
    callbacks[type][method] ||= []
    if callbacks[type][method].empty?
      alias_name = fake_alias_name
      alias_method alias_name, method
      private alias_name

      callback_klazz = self
      define_method method do |*args|
        callback_klazz.__send__(:execute_before_callbacks, method, self, *args)
        result = callback_klazz.__send__(:execute_around_callbacks, method, alias_name, self, *args)
        callback_klazz.__send__(:execute_after_callbacks, method, self, *args, result)
        result
      end

      callbacks[type][method] << block
    else
      callbacks[type][method] << block
    end
  end

  def fake_alias_name
    ['__callbacks__', SecureRandom.hex].join
  end

  def execute_before_callbacks(method, object, *args)
    filter_callbacks(:before, method).each do |callback|
      verify_callback(callback)
      callback.call(args, object)
    end
  end

  def execute_around_callbacks(method, alias_name, object, *args)
    around_callbacks = filter_callbacks(:around, method)
    if around_callbacks.empty?
      object.__send__(alias_name, *args)
    elsif around_callbacks.size === 1
      callback = around_callbacks.first
      verify_callback(callback)
      callback.call(object.method(alias_name), args, object)
    else
      raise MultipleAroundCallbacks.new 'Only one around callback is allowed per method'
    end
  end

  def execute_after_callbacks(method, object, *args, result)
    filter_callbacks(:after, method).each do |callback|
      verify_callback(callback)
      callback.call(args, object, result)
    end
  end

  def verify_callback(callback)
    raise CallbackNotDefined.new 'Callback should be a Proc function' unless callback
  end
end
