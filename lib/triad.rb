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
    finder = case arg
            when Symbol then :key
            when String then :descriptor
            else :value
            end
    Finder.new(arg, @storage, finder).keys
  end

  def descriptors(arg)
    finder = case arg
            when Symbol then :key
            when String then :descriptor
            else :value
            end
    Finder.new(arg, @storage, finder).descriptors
  end

  def values(arg)
    finder = case arg
            when Symbol then :key
            when String then :descriptor
            else :value
            end
    Finder.new(arg, @storage, finder).values
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
