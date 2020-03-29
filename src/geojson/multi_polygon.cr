module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.7
  class MultiPolygon < Object
    getter type : String = "MultiPolygon"

    getter coordinates : Array(Array(Array(GeoJSON::Coordinates)))

    delegate "[]", to: coordinates

    def initialize(coordinates : Array(Polygon), *, @bbox = nil)
      @coordinates = coordinates.map(&.coordinates)
    end

    def initialize(coordinates : Array(Array(Array(Array(Float64)))), *, @bbox = nil)
      @coordinates = coordinates.map do |arry|
        Polygon.new(arry).coordinates
      end
    end

    def <<(polygon : Array(Polygon))
      @coordinates << polygon.coordinates
    end

    def <<(coordinate : Array(Array(Array(Float64))))
      @coordinates << Polygon.new(coordinate).coordinates
    end
  end
end
