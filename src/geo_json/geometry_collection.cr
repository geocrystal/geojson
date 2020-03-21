module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.1.8
  class GeometryCollection < Object
    getter type : String = "GeometryCollection"

    getter geometries : Array(Type) = Array(GeoJSON::Object::Type).new

    def initialize(geometries : Array(Type))
      @geometries += geometries
    end

    def self.new(pull : JSON::PullParser)
      pull.read_begin_object

      until pull.kind.end_object?
        case pull.kind
        when .string?
          pull.read_string
        else
          pull.read_next
        end
      end

      pull.read_end_object

      # TODO
      geometries = [Point.new([0.0, 0.0])]
      GeoJSON::GeometryCollection.new(geometries)
    end
  end
end
