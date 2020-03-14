module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.7
  class MultiPolygon < Object
    getter type : String = "MultiPolygon"

    getter coordinates : Array(Polygon)

    delegate "[]", to: coordinates

    def initialize(@coordinates : Array(Polygon))
    end

    def initialize(coordinates : Array(Array(Array(Array(Float64)))))
      @coordinates = coordinates.map do |arry|
        Polygon.new(arry)
      end
    end

    def <<(polygon : Array(Polygon))
      @coordinates << polygon
    end

    def <<(coordinate : Array(Array(Array(Float64))))
      @coordinates << Polygon.new(coordinate)
    end
  end
end
