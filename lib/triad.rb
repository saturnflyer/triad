require "triad/version"
require "triad/finder"

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
    if arg.is_a?(Symbol)
      Finder.new(arg, @storage, :key).keys
    elsif arg.is_a?(String)
      Finder.new(arg, @storage, :descriptor).keys
    else
      Finder.new(arg, @storage, :value).keys
    end
  end

  def descriptors(arg)
    if arg.is_a?(String)
      Finder.new(arg, @storage, :descriptor).descriptors
    elsif arg.is_a?(Symbol)
      Finder.new(arg, @storage, :key).descriptors
    else
      Finder.new(arg, @storage, :value).descriptors
    end
  end

  def values(arg)
    if !arg.is_a?(String) && !arg.is_a?(Symbol)
      Finder.new(arg, @storage, :value).values
    elsif arg.is_a?(Symbol)
      Finder.new(arg, @storage, :key).values
    else
      Finder.new(arg, @storage, :descriptor).values
    end
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
