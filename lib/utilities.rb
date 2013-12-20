module Rlocu

  class Location
    attr_accessor :lat, :long
    def initialize(lat, long)
      if !lat.is_a?(Numeric) || !long.is_a?(Numeric)
        raise ArgumentError.new "Lat and long must be numeric (floats)" 
      end
      @lat = lat
      @long = long
    end

    def to_s
      "#{lat},#{long}"
    end
  end

  class Bounds
    def initialize(loc1, loc2)
      @loc1 = loc1
      @loc2 = loc2
    end

    def to_s
      "#{@loc1.to_s}|#{@loc2.to_s}"
    end
  end

end