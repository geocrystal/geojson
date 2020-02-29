module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.2
  class Point < Object
    getter type : String = "Point"

    getter coordinates : Coordinates

    def initialize(*, longitude, latitude, altitude = nil)
      if altitude
        @coordinates = Coordinates.new([longitude, latitude, altitude])
      else
        @coordinates = Coordinates.new([longitude, latitude])
      end
    end

    delegate longitude, to: coordinates
    delegate latitude, to: coordinates
    delegate altitude, to: coordinates
  end
end
