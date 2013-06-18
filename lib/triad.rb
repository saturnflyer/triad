require "triad/version"

class Triad
  include Enumerable

  class InvalidAddition < StandardError
    def message
      "your array length must be 3"
    end
  end

  # stored as {key => ['Descriptor', value]}
  def initialize(*args)
    @storage = {}
  end

  def key(arg)
    if arg.is_a?(String)
      key_from_descriptor(arg)
    else
      key_from_value(arg)
    end
  end

  def key_from_descriptor(descriptor)
    triad = @storage.find{|_, array|
      array[0] == descriptor
    }
    triad && triad[0]
  end

  def key_from_value(value)
    triad = @storage.find{|_, array|
      array[1] == value
    }
    triad && triad[0]
  end

  def descriptor(arg)
    if arg.is_a?(Symbol)
      descriptor_from_key(arg)
    else
      descriptor_from_value(arg)
    end
  end

  def descriptor_from_key(key)
    array = @storage[key]
    array && array[0]
  end

  def descriptor_from_value(value)
    triad = @storage.find{|_, array|
      array[1] == value
    }
    triad && triad[1][0]
  end

  def value(arg)
    if arg.is_a?(Symbol)
      value_from_key(arg)
    else
      value_from_descriptor(arg)
    end
  end

  def value_from_key(key)
    array = @storage[key]
    array && array[1]
  end

  def value_from_descriptor(descriptor)
    triad = @storage.find{|_, array|
      array[0] == descriptor
    }
    triad && triad[1][1]
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
