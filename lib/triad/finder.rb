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

    def keys
      with_interest.keys
    end

    def values
      with_interest.map{|key, array| [key, array].flatten[positions.index(:value)] }
    end

    def descriptors
      with_interest.map{|key, array| [key, array].flatten[positions.index(:descriptor)] }
    end

    private

    def raise_error
      error_name = type.to_s.gsub(/(?:^|_)([a-z])/) { $1.upcase }
      error_class = Triad.const_get("#{error_name}NotPresent")
      raise error_class.new
    end

    def with_interest
      lookup = storage.select{|key, array|
        [key, array].flatten[positions.index(type)] == interest
      }
      raise_error if lookup.empty?
      lookup
    end
  end
end