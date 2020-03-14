module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.3
  class MultiPoint < Object
    getter type : String = "MultiPoint"

    getter coordinates : Array(Coordinates)

    delegate "[]", to: coordinates

    def initialize(coordinates : Array(Point))
      @coordinates = coordinates.map(&.coordinates)
    end

    def initialize(coordinates : Array(Array(Float64)))
      @coordinates = coordinates.map do |coordinates|
        Point.new(coordinates).coordinates
      end
    end

    def <<(point : Array(Point))
      @coordinates << point.coordinates
    end

    def <<(coordinate : Array(Float64))
      @coordinates << Point.new(coordinate).coordinates
    end
  end
end
