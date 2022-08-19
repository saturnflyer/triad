require "triad/version"
require "concurrent/hash"

class Triad
  include Enumerable

  class InvalidAddition < StandardError; end
  class ItemNotPresent < StandardError; end

  # stored as {key => ['Descriptor', value]}
  def initialize
    @storage = Concurrent::Hash.new
  end
  attr_reader :storage
  private :storage

  # Return the keys for a given descriptor or value
  def keys(arg=nil)
    if arg == nil
      storage.keys
    else
      with_interest(arg).map{|key, _, _| key }
    end
  end

  # Return the descriptors for a given key or value
  def descriptors(arg=nil)
    if arg.nil?
      storage.map{|_,(descriptor,_)| descriptor }
    else
      with_interest(arg).map{|_, descriptor, _| descriptor }
    end
  end

  # Return the values for a given key or descriptor
  def values(arg=:__no_argument_given__)
    if arg == :__no_argument_given__
      storage.map{|_,(_,value)| value }.uniq
    else
      with_interest(arg).map{|_, _, value| value }
    end
  end

  # Add new entries to the object
  def <<(array)
    raise InvalidAddition.new("your array length must be 3") if array.length != 3
    array_key = array.fetch(0)
    raise InvalidAddition.new("the provided key must be a Symbol") unless array_key.is_a?(Symbol)
    raise InvalidAddition.new("the provided key already exists") if key_exists?(array_key)

    array_descriptor = array.fetch(1)
    raise InvalidAddition.new("the provided descriptor must be a String") unless array_descriptor.is_a?(String)
    array_value =      array.fetch(2)

    storage[array_key] = [array_descriptor, array_value]
    self
  end

  # Alter the descriptor and value in-place for the given key
  def update(key, descriptor, value)
    raise InvalidAddition.new("the provided descriptor cannot be nil") if descriptor.nil?
    storage[key] = [descriptor, value]
  end

  def each
    storage.each do |key, (descriptor, value)|
      yield key, descriptor, value
    end
  end

  private

  def key_exists?(key)
    storage.key?(key)
  end

  def descriptor_exists?(descriptor)
    storage.values.map{|arr| arr.fetch(0) }.include?(descriptor)
  end

  def value_exists?(value)
    storage.values.map{|arr| arr.fetch(1) }.include?(value)
  end

  def with_interest(interest)
    position = case
              when key_exists?(interest)        then 0
              when descriptor_exists?(interest) then 1
              when value_exists?(interest)      then 2
              else
                raise ItemNotPresent.new
              end

    storage.select{|key, array|
      [key, *array].fetch(position) == interest
    }.map{|key, array| [key, *array] }
  end
end
