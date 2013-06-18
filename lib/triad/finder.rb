class Triad
  class ValueNotPresent < StandardError; end
  class DescriptorNotPresent < StandardError; end
  class KeyNotPresent < StandardError; end

  class Finder
    def initialize(interest, storage)
      @interest, @storage = interest, storage
    end
    attr_reader :interest, :storage
    private :storage
  end

  class KeyFinder < Finder
    def values
      [details.last]
    end

    def keys
      details && [interest]
    end

    def descriptors
      [details.first]
    end

    private

    def details
      storage.fetch(interest){ raise KeyNotPresent.new }
    end
  end

  class ValueFinder < Finder
    def keys
      with_value.keys
    end

    def values
      with_value.values.map{|_,value| value }
    end

    def descriptors
      with_value.values.map{|descriptor,_| descriptor }
    end

    private

    def with_value
      lookup = storage.select{ |key, array|
        array.last == interest
      }
      raise ValueNotPresent.new if lookup.empty?
      lookup
    end
  end

  class DescriptorFinder < Finder
    def keys
      with_descriptor.keys
    end

    def values
      with_descriptor.values.map{|_,value| value }
    end

    def descriptors
      with_descriptor.values.map{|descriptor,_| descriptor }
    end

    private

    def with_descriptor
      lookup = storage.select{ |key, array|
        array.first == interest
      }
      raise DescriptorNotPresent.new if lookup.empty?
      lookup
    end
  end
end