module GeoJSON
  # A `MultiPolygon` is a `Geometry` representing several `Polygon`s.
  #
  # This class corresponds to the [GeoJSON MultiPolygon](https://tools.ietf.org/html/rfc7946#section-3.1.7).
  class MultiPolygon < Object
    # Gets this MultiPolygon's GeoJSON type ("MultiPolygon")
    getter type : String = "MultiPolygon"

    # Returns an array of this MultiPolygon's coordinates.
    getter coordinates : Array(Array(Array(GeoJSON::Coordinates)))

    # Gets the `Polygon` at the given index.
    delegate "[]", to: coordinates

    # Create a new `MultiPolygon` with the given *coordinates* and optional
    # bounding box *bbox*.
    def initialize(coordinates : Array(Polygon), *, @bbox = nil)
      @coordinates = coordinates.map(&.coordinates)
    end

    # :ditto:
    def initialize(coordinates : Array(Array(Array(Array(Float64)))), *, @bbox = nil)
      @coordinates = coordinates.map do |arry|
        Polygon.new(arry).coordinates
      end
    end

    # Adds the given *polygon* to this MultiPolygon.
    def <<(polygon : Array(Polygon))
      @coordinates << polygon.coordinates
    end

    # Adds the given *coordinate* to this MultiPolygon.
    def <<(coordinate : Array(Array(Array(Float64))))
      @coordinates << Polygon.new(coordinate).coordinates
    end
  end
end
