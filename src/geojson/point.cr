module GeoJSON
  # A `Point` is a `Geometry` representing a single `Position` in geographic
  # space.
  #
  # This class corresponds to the [GeoJSON Point](https://tools.ietf.org/html/rfc7946#section-3.1.2).
  class Point < Object
    # Gets this Point's GeoJSON type ("Point")
    getter type : String = "Point"

    # Returns this Point's coordinates.
    getter coordinates : Coordinates

    # Creates a new `Point` at the given *longitude*, *latitude*, and optional
    # *altitude*, and with optional bounding box *bbox*.
    def initialize(*, longitude, latitude, altitude = nil, @bbox = nil)
      if altitude
        @coordinates = Coordinates.new([longitude, latitude, altitude])
      else
        @coordinates = Coordinates.new([longitude, latitude])
      end
    end

    # Creates a new `Point` with the given *coordinates* and optional bounding
    # box *bbox*.
    def initialize(@coordinates : GeoJSON::Coordinates, *, @bbox = nil)
    end

    # :ditto:
    def initialize(coordinates : Array(Float64), *, @bbox = nil)
      @coordinates = GeoJSON::Coordinates.new(coordinates)
    end

    # Gets this Point's longitude in decimal degrees according to WGS84.
    delegate longitude, to: coordinates
    # Gets this Point's latitude in decimal degrees according to WGS84.
    delegate latitude, to: coordinates
    # Gets this Point's altitude.
    #
    # Technically, this positional value is meant to be the height in meters
    # above the WGS84 ellipsoid.
    delegate altitude, to: coordinates

    def_equals_and_hash coordinates
  end
end
