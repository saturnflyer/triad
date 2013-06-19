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
  attr_reader :storage
  private :storage

  def keys(arg)
    with_interest(arg).map{|key, _, _| key }
  end

  def descriptors(arg)
    with_interest(arg).map{|_, descriptor, _| descriptor }
  end

  def values(arg)
    with_interest(arg).map{|_, _, value| value }
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

  def positions
    [:key, :descriptor, :value]
  end

  def argument_type(arg)
    case arg
    when Symbol then :key
    when String then :descriptor
    else :value
    end
  end

  def raise_error(type)
    error_name = type.to_s.gsub(/(?:^|_)([a-z])/) { $1.upcase }
    error_class = Triad.const_get("#{error_name}NotPresent")
    raise error_class.new
  end

  def with_interest(interest)
    lookup = storage.select{|key, array|
      [key, array].flatten[positions.index(argument_type(interest))] == interest
    }
    raise_error(argument_type(interest)) if lookup.empty?
    lookup.map{|key, array| [key, array].flatten }
  end
end
