module GeoJSON
  # A `LineString` is a `Geometry` representing two or more points in geographic
  # space connected consecutively by lines.
  #
  # This class corresponds to the [GeoJSON LineString](https://tools.ietf.org/html/rfc7946#section-3.1.4).
  class LineString < Object
    # Gets this LineString's GeoJSON type ("LineString")
    getter type : String = "LineString"

    # Gets this LineString's GeoJSON type ("LineString")
    getter coordinates : Array(Coordinates)

    # Gets the LineString vertex at the given index.
    delegate "[]", to: coordinates

    # Create a new `LineString` with the given *coordinates* and optional
    # bounding box *bbox*.
    def initialize(@coordinates : Array(Coordinates), *, @bbox = nil)
      raise_if_invalid
    end

    # :ditto:
    def initialize(coordinates : Array(Point), *, @bbox = nil)
      @coordinates = coordinates.map(&.coordinates)

      raise_if_invalid
    end

    # :ditto:
    def initialize(coordinates : Array(Array(Float64)), *, @bbox = nil)
      @coordinates = coordinates.map { |e| Coordinates.new(e) }

      raise_if_invalid
    end

    def bbox
      return @bbox if @bbox

      result = [Float64::INFINITY, Float64::INFINITY, -Float64::INFINITY, -Float64::INFINITY]

      @coordinates.each do |coord|
        result[0] = coord[0] if result[0] > coord[0]
        result[1] = coord[1] if result[1] > coord[1]
        result[2] = coord[0] if result[2] < coord[0]
        result[3] = coord[1] if result[3] < coord[1]
      end

      result
    end

    private def raise_if_invalid
      if coordinates.size < 2
        raise GeoJSON::Exception.new("a line needs to have two or more coordinates to be valid")
      end
    end
  end
end
