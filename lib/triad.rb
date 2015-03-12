require "triad/version"
require 'thread_safe'

class Triad
  include Enumerable

  class InvalidAddition < StandardError; end
  class ItemNotPresent < StandardError; end

  # stored as {key => ['Descriptor', value]}
  def initialize
    @storage = ThreadSafe::Hash.new
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
    array_key = array[0]
    raise InvalidAddition.new("your array length must be 3") if array.length != 3
    raise InvalidAddition.new("the provided key already exists") if key_exists?(array_key)

    array_descriptor = array[1]
    array_value =      array[2]

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
  
  def descriptor_exists?(descriptor)
    storage.values.map{|arr| arr[0] }.include?(descriptor)
  end
  
  def value_exists?(value)
    storage.values.map{|arr| arr[1] }.include?(value)
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
