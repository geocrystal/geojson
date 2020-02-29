module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.2
  class Point < Object
    getter type : String = "Point"

    getter coordinates : Coordinates

    def initialize(*, longitude, latitude, altitude = nil)
      if altitude
        @coordinates = Coordinates.new([longitude, latitude, altitude])
      else
        @coordinates = Coordinates.new([longitude, latitude])
      end
    end

    def initialize(@coordinates : GeoJSON::Coordinates)
    end

    def initialize(coordinates : Array(Float64))
      @coordinates = GeoJSON::Coordinates.new(coordinates)
    end

    delegate longitude, to: coordinates
    delegate latitude, to: coordinates
    delegate altitude, to: coordinates

    def_equals_and_hash coordinates
  end
end
