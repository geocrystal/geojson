module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.3
  class MultiPoint < Object
    getter type : String = "MultiPoint"

    getter coordinates : Array(Point)

    def initialize(@coordinates : Array(Point))
    end

    def initialize(coordinates : Array(Array(Float64)))
      @coordinates = coordinates.map do |coordinates|
        Point.new(coordinates)
      end
    end

    def [](index : Int)
      coordinates[index]
    end

    def <<(point : Array(Point))
      @coordinates << point
    end

    def <<(coordinate : Array(Float64))
      @coordinates << Point.new(coordinate)
    end
  end
end
