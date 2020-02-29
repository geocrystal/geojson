module GeoJSON
  class Coordinates
    getter coordinates : Array(Float64)

    def initialize(@coordinates : Array(Float64))
      raise_if_invalid
    end

    def initialize(parser : JSON::PullParser)
      @coordinates = Array(Float64).new(parser)

      raise_if_invalid
    end

    def longitude
      coordinates[0]
    end

    def latitude
      coordinates[1]
    end

    def altitude
      coordinates[2]?
    end

    private def raise_if_invalid
      if coordinates.size < 2 || coordinates.size > 3
        raise "GeoJSON::Coordinates must have two or three coordinates"
      end
    end

    delegate to_json, to: coordinates

    def_equals_and_hash coordinates
  end
end
