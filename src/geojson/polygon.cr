module GeoJSON
  # A `Polygon` is a `Geometry` representing a closed geometric figure in
  # geographic space with optional holes within it.
  #
  # This class corresponds to the [GeoJSON Polygon](https://tools.ietf.org/html/rfc7946#section-3.1.6).
  class Polygon < Object
    # Gets this Polygon's GeoJSON type ("Polygon")
    getter type : String = "Polygon"

    # Returns this Polygon's linear ring coordinates.
    getter coordinates : Array(Array(Coordinates))

    # Creates a new `Polygon` with the given *coordinates* and optional bounding
    # box *bbox*.
    def initialize(@coordinates : Array(Array(Coordinates)), *, @bbox = nil)
      raise_if_invalid
    end

    # :ditto:
    def initialize(coordinates : Array(Array(Point)), *, @bbox = nil)
      @coordinates = coordinates.map do |ring|
        ring.map { |point| point.coordinates }
      end

      raise_if_invalid
    end

    # :ditto:
    def initialize(coordinates : Array(Array(Array(Float64))), *, @bbox = nil)
      @coordinates = coordinates.map do |ring|
        ring.map { |e| Coordinates.new(e) }
      end

      raise_if_invalid
    end

    private def raise_if_invalid
      if coordinates.empty?
        "a number was found where a coordinate array should have been found: this needs to be nested more deeply"
        raise GeoJSON::Exception.new("a coordinate array should have been found")
      end

      coordinates.each do |ring|
        if ring.size < 4
          raise GeoJSON::Exception.new("a LinearRing of coordinates needs to have four or more positions")
        end

        unless ring.first == ring.last
          raise GeoJSON::Exception.new("the first and last positions in a LinearRing of coordinates must be the same")
        end
      end
    end
  end
end
