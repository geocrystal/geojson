module GeoJSON
  # A `Coordinates` is a position in longitude, latitude, and (optionally)
  # altitude.
  #
  # This class corresponds to the [GeoJSON Position](https://tools.ietf.org/html/rfc7946#section-3.1.1).
  class Coordinates
    getter coordinates : Array(Float64)

    # Creates a new `Coordinates` with the given *coordinates* array.
    def initialize(@coordinates : Array(Float64))
      raise_if_invalid
    end

    # Deserializes a `Coordinates` from the given JSON *parser*.
    def self.new(parser : JSON::PullParser)
      coordinates = Array(Float64).new(parser)

      new(coordinates)
    end

    # Creates a new `Coordinates` with the given *longitude*, *latitude* and *altitude*.
    def self.new(longitude : Float64, latitude : Float64, altitude : Float64? = nil)
      if altitude
        new([longitude, latitude, altitude])
      else
        new([longitude, latitude])
      end
    end

    # Gets this Coordinates' longitude in decimal degrees according to WGS84.
    def longitude
      coordinates[0]
    end

    # Gets this Coordinates' latitude in decimal degrees according to WGS84.
    def latitude
      coordinates[1]
    end

    # Gets this Coordinates' altitude.
    #
    # Technically, this positional value is meant to be the height in meters
    # above the WGS84 ellipsoid.
    def altitude
      coordinates[2]?
    end

    private def raise_if_invalid
      if coordinates.size < 2 || coordinates.size > 3
        raise GeoJSON::Exception.new("coordinates need to have have two or three elements")
      end
    end

    delegate to_json, to: coordinates

    def_equals_and_hash coordinates
  end
end
