require "triad/version"

class Triad
  include Enumerable

  class InvalidAddition < StandardError
    def message
      "your array length must be 3"
    end
  end
  class ValueNotPresent < StandardError; end
  class DescriptorNotPresent < StandardError; end
  class KeyNotPresent < StandardError; end

  # stored as {key => ['Descriptor', value]}
  def initialize(*args)
    @storage = {}
  end

  def keys(arg)
    if arg.is_a?(Symbol)
      if @storage.has_key?(arg)
        [arg]
      else
        fetch(arg)
      end
    elsif arg.is_a?(String)
      keys_from_descriptor(arg)
    else
      keys_from_value(arg)
    end
  end

  def keys_from_descriptor(descriptor)
    hash = with_descriptor(descriptor)
    hash.keys
  end

  def keys_from_value(value)
    hash = with_value(value)
    hash.keys
  end

  def descriptors(arg)
    if arg.is_a?(String)
      descriptors_from_descriptor(arg)
    elsif arg.is_a?(Symbol)
      descriptors_from_key(arg)
    else
      descriptors_from_value(arg)
    end
  end

  def descriptors_from_key(key)
    fetch(key, :first)
  end

  def descriptors_from_descriptor(descriptor)
    hash = with_descriptor(descriptor)
    hash.values.map{|arr| arr.first }
  end

  def descriptors_from_value(value)
    hash = with_value(value)
    hash.values.map{|arr| arr.first }
  end

  def with_value(value)
    lookup = @storage.select{ |key, array|
      array.last == value
    }
    raise ValueNotPresent.new if lookup.empty?
    lookup
  end

  def values(arg)
    if !arg.is_a?(String) && !arg.is_a?(Symbol)
      values_from_value(arg)
    elsif arg.is_a?(Symbol)
      values_from_key(arg)
    else
      values_from_descriptor(arg)
    end
  end

  def values_from_key(key)
    fetch(key, :last)
  end

  def values_from_descriptor(descriptor)
    hash = with_descriptor(descriptor)
    hash.values.map{|arr| arr.last }
  end

  def values_from_value(value)
    hash = with_value(value)
    hash.values.map{|arr| arr.last }
  end

  def with_descriptor(descriptor)
    lookup = @storage.select{ |key, array|
      array.first == descriptor
    }
    raise DescriptorNotPresent.new if lookup.empty?
    lookup
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

  private

  def fetch(key, locator=:first)
    Array(@storage.fetch(key){ raise KeyNotPresent.new }.send(locator))
  end
end
