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

    def key_position
      0
    end

    def descriptor_position
      1
    end

    def value_position
      2
    end

    def interest_position
      basename = self.class.name.split('::').last
      interest_name = basename.sub('Finder','').downcase
      self.send("#{interest_name}_position")
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
      error_name = self.class.name.sub('Finder','NotPresent')
      error_class = Object.const_get("::Triad::#{error_name}")
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

  class KeyFinder < Finder
  end

  class ValueFinder < Finder
  end

  class DescriptorFinder < Finder
  end
end