require "triad/version"
require "concurrent/hash"

class Triad
  include Enumerable

  class InvalidAddition < StandardError; end

  class ItemNotPresent < StandardError; end

  # stored as {key => {descriptor: 'Descriptor', value: value}}
  def initialize
    @storage = Concurrent::Hash.new
    @descriptor_index = Concurrent::Hash.new
    @value_index = Concurrent::Hash.new
  end
  attr_reader :storage, :descriptor_index, :value_index
  private :storage, :descriptor_index, :value_index

  # Return the keys for a given descriptor or value
  def keys(arg = nil)
    if arg.nil?
      storage.keys
    else
      with_interest(arg).map { |key, _, _| key }
    end
  end

  # Return the descriptors for a given key or value
  def descriptors(arg = nil)
    if arg.nil?
      storage.map { |_, data| data[:descriptor] }
    else
      with_interest(arg).map { |_, descriptor, _| descriptor }
    end
  end

  # Return the values for a given key or descriptor
  def values(arg = :__no_argument_given__)
    if arg == :__no_argument_given__
      value_index.keys
    else
      with_interest(arg).map { |_, _, value| value }
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
    array_value = array.fetch(2)

    add_to_storage(array_key, array_descriptor, array_value)
    self
  end

  # Alter the descriptor and value in-place for the given key
  def update(key, descriptor, value)
    raise InvalidAddition.new("the provided descriptor cannot be nil") if descriptor.nil?
    remove_from_indices(key) if storage.key?(key)
    add_to_storage(key, descriptor, value)
  end

  def each
    storage.each do |key, data|
      yield key, data[:descriptor], data[:value]
    end
  end

  private

  def add_to_storage(key, descriptor, value)
    storage[key] = { descriptor: descriptor, value: value }
    descriptor_index[descriptor] = (descriptor_index[descriptor] || []) << key
    value_index[value] = (value_index[value] || []) << key
  end

  def remove_from_indices(key)
    return unless storage.key?(key)

    data = storage[key]
    descriptor = data[:descriptor]
    value = data[:value]

    descriptor_index[descriptor]&.delete(key)
    descriptor_index.delete(descriptor) if descriptor_index[descriptor]&.empty?

    value_index[value]&.delete(key)
    value_index.delete(value) if value_index[value]&.empty?
  end

  def key_exists?(key)
    storage.key?(key)
  end

  def descriptor_exists?(descriptor)
    descriptor_index.key?(descriptor)
  end

  def value_exists?(value)
    value_index.key?(value)
  end

  def with_interest(interest)
    if key_exists?(interest)
      data = storage[interest]
      [[interest, data[:descriptor], data[:value]]]
    elsif descriptor_exists?(interest)
      descriptor_index[interest].map do |key|
        data = storage[key]
        [key, data[:descriptor], data[:value]]
      end
    elsif value_exists?(interest)
      value_index[interest].map do |key|
        data = storage[key]
        [key, data[:descriptor], data[:value]]
      end
    else
      raise ItemNotPresent.new
    end
  end
end
