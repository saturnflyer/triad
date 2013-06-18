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

  def keys(arg)
    if arg.is_a?(String)
      keys_from_descriptor(arg)
    else
      keys_from_value(arg)
    end
  end

  def keys_from_descriptor(descriptor)
    triad = @storage.find{|_, array|
      array[0] == descriptor
    }
    triad && triad[0]
  end

  def keys_from_value(value)
    triad = @storage.find{|_, array|
      array[1] == value
    }
    triad && triad[0]
  end

  def descriptors(arg)
    if arg.is_a?(Symbol)
      descriptors_from_key(arg)
    else
      descriptors_from_value(arg)
    end
  end

  def descriptors_from_key(key)
    array = @storage[key]
    array && array[0]
  end

  def descriptors_from_value(value)
    triad = @storage.find{|_, array|
      array[1] == value
    }
    triad && triad[1][0]
  end

  def values(arg)
    if arg.is_a?(Symbol)
      values_from_key(arg)
    else
      values_from_descriptor(arg)
    end
  end

  def values_from_key(key)
    array = @storage[key]
    array && array[1]
  end

  def values_from_descriptor(descriptor)
    triad = @storage.find{|_, array|
      array[0] == descriptor
    }
    triad && triad[1][1]
  end

  def <<(array)
    array_key = array.find{|item| item.is_a?(Symbol) }
    raise InvalidAddition if array.length != 3 || @storage.has_key?(array_key)
    array_descriptor = array.find{|item| item.is_a?(String) }
    array_value = array.find{|item| !item.is_a?(String) && !item.is_a?(Symbol) }
    @storage[array_key] = [array_descriptor, array_value]
    self
  end

  def each
    @storage.each do |key, (descriptor, value)|
      yield key, descriptor, value
    end
  end
end
