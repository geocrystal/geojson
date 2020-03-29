module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.8
  class GeometryCollection < Object
    getter type : String = "GeometryCollection"

    getter geometries : Array(GeoJSON::Object::Type) = Array(GeoJSON::Object::Type).new

    def initialize(geometries : Array(GeoJSON::Object::Type), *, @bbox = nil)
      @geometries += geometries
    end

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
  end
end
