module GeoJSON
  # A `MultiPoint` is a `Geometry` representing several `Point`s.
  #
  # This class corresponds to the [GeoJSON MultiPoint](https://tools.ietf.org/html/rfc7946#section-3.1.3).
  class MultiPoint < Object
    # Gets this MultiPoint's GeoJSON type ("MultiPoint")
    getter type : String = "MultiPoint"

    # Returns an array of this MultiPoint's coordinates.
    getter coordinates : Array(Coordinates)

    # Gets the `Point` at the given index.
    delegate "[]", to: coordinates

    # Create a new `MultiPoint` with the given *coordinates* and optional
    # bounding box *bbox*.
    def initialize(coordinates : Array(Point), *, @bbox = nil)
      @coordinates = coordinates.map(&.coordinates)
    end

    # :ditto:
    def initialize(coordinates : Array(Array(Float64)), *, @bbox = nil)
      @coordinates = coordinates.map do |coordinates|
        Point.new(coordinates).coordinates
      end
    end

    # Adds the given *point* to this MultiPoint.
    def <<(point : Array(Point))
      @coordinates << point.coordinates
    end

    # Adds the given *coordinate* to this MultiPoint.
    def <<(coordinate : Array(Float64))
      @coordinates << Point.new(coordinate).coordinates
    end
  end
end
