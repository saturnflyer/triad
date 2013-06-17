require "triad/version"

class Triad
  include Enumerable

  def initialize(*args)
    @keys = []
    @descriptors = []
    @values = []
  end

  attr_reader :keys, :descriptors, :values
  private :keys, :descriptors, :values

  def key(string_or_object)
    collection = string_or_object.is_a?(String) ? descriptors : values
    keys[collection.index(string_or_object)]
  end

  def descriptor(sym_or_object)
    collection = sym_or_object.is_a?(Symbol) ? keys : values
    descriptors[collection.index(sym_or_object)]
  end

  def value(symbol_or_string)
    collection = symbol_or_string.is_a?(Symbol) ? keys : descriptors
    values[collection.index(symbol_or_string)]
  end

  def <<(array)
    raise "your array length must be 3" unless array.length == 3
    array_key = array.find{|item| item.is_a?(Symbol) }
    array_descriptor = array.find{|item| item.is_a?(String) }
    array_value = array.find{|item| !item.is_a?(String) && !item.is_a?(Symbol) }
    keys << array_key
    descriptors << array_descriptor
    values << array_value
    self
  end

  def each
    yield keys.zip(descriptors, values)
  end
end
