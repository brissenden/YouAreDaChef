require 'YouAreDaChef/version'
require 'securerandom'

module YouAreDaChef
  def callbacks
    @callbacks ||= default_callbacks
  end

  def before(method, callback)
    define_callback(:before, method, callback)
  end

  def after(method, callback)
    define_callback(:after, method, callback)
  end

  def remove_all_callbacks
    @callbacks = default_callbacks
  end

  private
  def default_callbacks
    { before: {}, after: {} }
  end

  def filter_callbacks(type, method)
    callbacks[type][method] || []
  end

  def define_callback(type, method, block)
    callbacks[type][method] ||= []
    callbacks[type][method] << block

    alias_name = fake_alias_name

    alias_method alias_name, method
    private alias_name

    callback_klazz = self
    define_method method do |*args|
      callback_klazz.send(:execute_before_callbacks, method, self, *args)
      result = send(alias_name, *args)
      callback_klazz.send(:execute_after_callbacks, method, self, *args, result)
      result
    end
  end

  def fake_alias_name
    SecureRandom.hex.to_sym
  end

  def execute_before_callbacks(method, object, *args)
    filter_callbacks(:before, method).each do |callback|
      callback.call(*args)
    end
  end

  def execute_after_callbacks(method, object, *args, result)
    filter_callbacks(:after, method).each do |callback|
      callback.call(*args, object, result)
    end
  end
end
