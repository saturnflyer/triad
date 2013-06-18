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
      storage.has_key?(interest) && [interest]
    end

    def descriptors
      [details.first]
    end

    private

    def details
      storage.fetch(interest){ raise KeyNotPresent.new }
    end
  end
end