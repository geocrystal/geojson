module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.6
  class Polygon < Object
    getter type : String = "Polygon"

    getter coordinates : Array(Array(Coordinates))

    def initialize(@coordinates : Array(Array(Coordinates)))
      raise_if_invalid
    end

    def initialize(coordinates : Array(Array(Point)))
      @coordinates = coordinates.map do |ring|
        ring.map { |point| point.coordinates }
      end

      raise_if_invalid
    end

    def initialize(coordinates : Array(Array(Array(Float64))))
      @coordinates = coordinates.map do |ring|
        ring.map { |e| Coordinates.new(e) }
      end

      raise_if_invalid
    end

    private def raise_if_invalid
      if coordinates.empty?
        raise "GeoJSON::Polygon must have at least one array of points"
      end

      if coordinates.first.size < 4
        raise "GeoJSON::Polygon must have four or more points"
      end

      unless coordinates.first.first == coordinates.first.last
        raise "GeoJSON::Polygon must have equivalent first and last positions"
      end
    end
  end
end
