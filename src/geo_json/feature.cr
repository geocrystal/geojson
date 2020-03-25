require "./object"

module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.2
  class Feature < Object
    getter type : String = "Feature"

    @[JSON::Field(emit_null: true)]
    getter geometry : GeoJSON::Object::Type?

    @[JSON::Field(emit_null: true)]
    getter properties : Hash(String, JSON::Any::Type)?

    getter id : String | Int32 | Nil

    def initialize(@geometry, @properties = nil, *, @id = nil, @bbox = nil)
    end
  end
end
