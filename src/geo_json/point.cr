module GeoJSON
  class Point < Object
    property type : String = "Point"

    property coordinates : Coordinates

    def initialize(*, longitude, latitude)
      @coordinates = Coordinates.new([longitude, latitude])
    end

    delegate longitude, to: coordinates
    delegate latitude, to: coordinates
  end
end
