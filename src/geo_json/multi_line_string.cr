module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.5
  class MultiLineString < Object
    getter type : String = "MultiLineString"

    getter coordinates : Array(Array(GeoJSON::Coordinates))

    delegate "[]", to: coordinates

    def initialize(coordinates : Array(LineString))
      @coordinates = coordinates.map(&.coordinates)
    end

    def initialize(coordinates : Array(Array(Array(Float64))))
      @coordinates = coordinates.map do |arry|
        LineString.new(arry).coordinates
      end
    end

    def <<(line_string : Array(LineString))
      @coordinates << line_string
    end

    def <<(coordinate : Array(Array(Float64)))
      @coordinates << LineString.new(coordinate).coordinates
    end
  end
end
