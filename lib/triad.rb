require "triad/version"

class Triad
  include Enumerable

  class InvalidAddition < StandardError; end
  class ValueNotPresent < StandardError; end
  class DescriptorNotPresent < StandardError; end
  class KeyNotPresent < StandardError; end

  # stored as {key => ['Descriptor', value]}
  def initialize(*args)
    @storage = {}
  end
  attr_reader :storage
  private :storage

  def keys(arg=:__no_argument_given__)
    if arg == :__no_argument_given__
      storage.keys
    else
      with_interest(arg).map{|key, _, _| key }
    end
  end

  def descriptors(arg=:__no_argument_given__)
    if arg == :__no_argument_given__
      storage.map{|_,(descriptor,_)| descriptor }
    else
      with_interest(arg).map{|_, descriptor, _| descriptor }
    end
  end

  def values(arg=:__no_argument_given__)
    if arg == :__no_argument_given__
      storage.map{|_,(_,value)| value }.uniq
    else
      with_interest(arg).map{|_, _, value| value }
    end
  end

  def <<(array)
    array_key = array.find{|item| item.is_a?(Symbol) }
    raise InvalidAddition.new("your array length must be 3") if array.length != 3
    raise InvalidAddition.new("the provided key already exists") if key_exists?(array_key)

    array_descriptor = array.find{|item| item.is_a?(String) }
    array_value =      array.find{|item| !item.is_a?(String) && !item.is_a?(Symbol) }

    storage[array_key] = [array_descriptor, array_value]
    self
  end

  def update(key, descriptor, value)
    storage[key] = [descriptor, value]
  end

  def each
    storage.each do |key, (descriptor, value)|
      yield key, descriptor, value
    end
  end

  private

  def key_exists?(key)
    storage.has_key?(key)
  end

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
    type = argument_type(interest)
    index = positions.index(type)

    lookup = storage.select{|key, array|
      [key, *array][index] == interest
    }.map{|key, array| [key, *array] }

    raise_error(type) if lookup.empty?

    lookup
  end
end
