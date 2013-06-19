class Triad
  class ValueNotPresent < StandardError; end
  class DescriptorNotPresent < StandardError; end
  class KeyNotPresent < StandardError; end

  class Finder
    def initialize(interest, storage, type=:key)
      @interest, @storage, @type = interest, storage, type
    end
    attr_reader :interest, :storage, :type
    private :storage

    def positions
      [:key, :descriptor, :value]
    end

    def key_position
      positions.index(:key)
    end

    def descriptor_position
      positions.index(:descriptor)
    end

    def value_position
      positions.index(:value)
    end

    def interest_position
      self.send("#{type}_position")
    end

    def keys
      with_interest.keys
    end

    def values
      with_interest.map{|key, array| [key, array].flatten[value_position] }
    end

    def descriptors
      with_interest.map{|key, array| [key, array].flatten[descriptor_position] }
    end

    private

    def raise_error
      error_name = type.to_s.gsub(/(?:^|_)([a-z])/) { $1.upcase }
      error_class = Triad.const_get("#{error_name}NotPresent")
      raise error_class.new
    end

    def with_interest
      lookup = storage.select{|key, array|
        [key, array].flatten[interest_position] == interest
      }
      raise_error if lookup.empty?
      lookup
    end
  end
end