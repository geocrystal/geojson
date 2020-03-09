module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.5
  class MultiLineString < Object
    getter type : String = "MultiLineString"

    getter coordinates : Array(LineString)

    delegate "[]", to: coordinates

    def initialize(@coordinates : Array(LineString))
    end

    def initialize(coordinates : Array(Array(Array(Float64))))
      @coordinates = coordinates.map do |arry|
        LineString.new(arry)
      end
    end

    def <<(line_string : Array(LineString))
      @coordinates << line_string
    end

    def <<(coordinate : Array(Array(Float64)))
      @coordinates << LineString.new(coordinate)
    end
  end
end
