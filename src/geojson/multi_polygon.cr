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

    def bbox
      return @bbox if @bbox

      result = [Float64::INFINITY, Float64::INFINITY, -Float64::INFINITY, -Float64::INFINITY]

      @coordinates.each do |polygon|
        polygon.each do |ring|
          ring.each do |coord|
            result[0] = coord[0] if result[0] > coord[0]
            result[1] = coord[1] if result[1] > coord[1]
            result[2] = coord[0] if result[2] < coord[0]
            result[3] = coord[1] if result[3] < coord[1]
          end
        end
      end

      result
    end
  end
end
