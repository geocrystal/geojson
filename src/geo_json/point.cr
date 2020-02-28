module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.2
  class Point < Object
    getter type : String = "Point"

    getter coordinates : Coordinates

    def initialize(*, longitude, latitude)
      @coordinates = Coordinates.new([longitude, latitude])
    end

    delegate longitude, to: coordinates
    delegate latitude, to: coordinates
  end
end
