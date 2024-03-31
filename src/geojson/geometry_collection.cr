module GeoJSON
  # A `GeometryCollection` represents a collection of several geometries.
  #
  # Its array of geometries can contain `Point`, `MultiPoint`, `LineString`,
  # `MultiLineString`, `Polygon`, and `MultiPolygon`. Technically, you can nest
  # `GeometryCollection`s inside one another, but this is discouraged by the
  # specification.
  #
  # This class corresponds to the [GeoJSON GeometryCollection](https://tools.ietf.org/html/rfc7946#section-3.1.8).
  class GeometryCollection < Object
    # Gets this GeometryCollection's GeoJSON type ("GeometryCollection")
    getter type : String = "GeometryCollection"

    # Returns an array of the geometries in this `GeometryCollection`
    getter geometries : Array(GeoJSON::Object::Type) = Array(GeoJSON::Object::Type).new

    # Creates a new `GeometryCollection` containing the given *geometries* and
    # optional bounding box *bbox*.
    def initialize(geometries : Array(GeoJSON::Object::Type), *, @bbox = nil)
      @geometries += geometries
    end

    # Deserializes a `GeometryCollection` from the given JSON *parser*.
    def self.new(pull : JSON::PullParser)
      geometries = [] of GeoJSON::Object::Type
      pull.read_begin_object

      until pull.kind.end_object?
        if pull.kind.string? && pull.read_string == "geometries"
          geometries = read_geometries(pull)
        else
          pull.read_next
        end
      end

      GeoJSON::GeometryCollection.new(geometries)
    end

    def self.read_geometries(pull : JSON::PullParser)
      geometries = [] of GeoJSON::Object::Type

      pull.read_begin_array

      until pull.kind.end_array?
        case pull.kind
        when .begin_object?
          if geometry = GeoJSON::Object.new(pull)
            geometries << geometry
          end
        else
          pull.read_next
        end
      end

      geometries
    end

    def bbox
      return @bbox if @bbox

      result = [Float64::INFINITY, Float64::INFINITY, -Float64::INFINITY, -Float64::INFINITY]

      geometries.each do |object|
        object.bbox.try do |object_bbox|
          result[0] = object_bbox[0] if result[0] > object_bbox[0]
          result[1] = object_bbox[1] if result[1] > object_bbox[1]
          result[2] = object_bbox[2] if result[2] < object_bbox[2]
          result[3] = object_bbox[3] if result[3] < object_bbox[3]
        end
      end

      result
    end
  end
end
