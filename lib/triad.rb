require "triad/version"

class Triad
  include Enumerable

  def initialize(*args)
    @storage = {}
  end

  attr_reader :keys, :descriptors, :values
  private :keys, :descriptors, :values

  def key(string_or_object)
    Array(@storage.find{|key, array|
      array[0] == string_or_object || array[1] == string_or_object
    }).first
  end

  def descriptor(sym_or_object)
    Array(Array(@storage.find{|key, array|
      array[0] == string_or_object || array[1] == string_or_object
    })[1])[0]
  end

  def value(symbol_or_string)
    Array(Array(@storage.find{|key, array|
      array[0] == string_or_object || array[1] == string_or_object
    })[1])[1]
  end

  def <<(array)
    raise "your array length must be 3" unless array.length == 3
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
