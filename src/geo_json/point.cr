module GeoJSON
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
