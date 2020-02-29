module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.4
  class LineString < Object
    getter type : String = "LineString"

    getter coordinates : Array(Coordinates)

    delegate "[]", to: coordinates

    def initialize(@coordinates : Array(Coordinates))
      raise_if_invalid
    end

    def initialize(coordinates : Array(Point))
      @coordinates = coordinates.map { |point| point.coordinates }

      raise_if_invalid
    end

    def initialize(coordinates : Array(Array(Float64)))
      @coordinates = coordinates.map { |e| Coordinates.new(e) }

      raise_if_invalid
    end

    private def raise_if_invalid
      if coordinates.size < 2
        raise "GeoJSON::LineString must have two or more points"
      end
    end
  end
end
