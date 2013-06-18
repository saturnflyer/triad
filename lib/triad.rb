require "triad/version"

class Triad
  include Enumerable

  class InvalidAddition < StandardError
    def message
      "your array length must be 3"
    end
  end

  def initialize(*args)
    @storage = {}
  end

  def key(arg)
    Array(@storage.find{|key, array|
      array[0] == arg || array[1] == arg
    }).first
  end

  def descriptor(arg)
    Array(Array(@storage.find{|key, array|
      key == arg || array[1] == arg
    })[1])[0]
  end

  def value(arg)
    Array(Array(@storage.find{|key, array|
      key == arg || array[0] == arg
    })[1])[1]
  end

  def <<(array)
    raise InvalidAddition unless array.length == 3
    array_key = array.find{|item| item.is_a?(Symbol) }
    array_descriptor = array.find{|item| item.is_a?(String) }
    array_value = array.find{|item| !item.is_a?(String) && !item.is_a?(Symbol) }
    @storage[array_key] = [array_descriptor, array_value]
    self
  end

  def each
    yield keys.zip(descriptors, values)
  end
end
