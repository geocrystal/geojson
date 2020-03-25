module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.4
  class LineString < Object
    getter type : String = "LineString"

    getter coordinates : Array(Coordinates)

    delegate "[]", to: coordinates

    def initialize(@coordinates : Array(Coordinates), *, @bbox = nil)
      raise_if_invalid
    end

    def initialize(coordinates : Array(Point), *, @bbox = nil)
      @coordinates = coordinates.map { |point| point.coordinates }

      raise_if_invalid
    end

    def initialize(coordinates : Array(Array(Float64)), *, @bbox = nil)
      @coordinates = coordinates.map { |e| Coordinates.new(e) }

      raise_if_invalid
    end

    private def raise_if_invalid
      if coordinates.size < 2
        raise GeoJSON::Exception.new("a line needs to have two or more coordinates to be valid")
      end
    end
  end
end
