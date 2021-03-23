module GeoJSON
  # A `MultiLineString` is a `Geometry` representing several `LineString`s.
  #
  # This class corresponds to the [GeoJSON MultiLineString](https://tools.ietf.org/html/rfc7946#section-3.1.5).
  class MultiLineString < Object
    # Gets this MultiLineString's GeoJSON type ("MultiLineString")
    getter type : String = "MultiLineString"

    # Returns an array of this MultiLineString's coordinates.
    getter coordinates : Array(Array(GeoJSON::Coordinates))

    # Gets the `LineString` at the given index.
    delegate "[]", to: coordinates

    # Create a new `MultiLineString` with the given *coordinates* and optional
    # bounding box *bbox*.
    def initialize(coordinates : Array(LineString), *, @bbox = nil)
      @coordinates = coordinates.map(&.coordinates)
    end

    # :ditto:
    def initialize(coordinates : Array(Array(Array(Float64))), *, @bbox = nil)
      @coordinates = coordinates.map do |arry|
        LineString.new(arry).coordinates
      end
    end

    # Adds the given *line_string* to this MultiLineString.
    def <<(line_string : Array(LineString))
      @coordinates << line_string
    end

    # Adds the given *coordinate* to this MultiLineString.
    def <<(coordinate : Array(Array(Float64)))
      @coordinates << LineString.new(coordinate).coordinates
    end
  end
end
