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
    Finder.new(arg, @storage, argument_type(arg)).keys
  end

  def descriptors(arg)
    Finder.new(arg, @storage, argument_type(arg)).descriptors
  end

  def values(arg)
    Finder.new(arg, @storage, argument_type(arg)).values
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

  def argument_type(arg)
    case arg
    when Symbol then :key
    when String then :descriptor
    else :value
    end
  end
end
