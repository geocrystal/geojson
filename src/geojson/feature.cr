require "./object"

module GeoJSON
  # A `Feature` represents a [GeoJSON Feature object](https://tools.ietf.org/html/rfc7946#section-3.2)
  # with a geometry and properties.
  class Feature < Object
    # Gets this Feature's GeoJSON type ("Feature")
    getter type : String = "Feature"

    @[JSON::Field(emit_null: true)]
    # Gets this Feature's geometry.
    getter geometry : GeoJSON::Object::Type?

    @[JSON::Field(emit_null: true)]
    # Gets this Feature's properties.
    getter properties : Hash(String, JSON::Any::Type)?

    # Gets this Feature's id.
    getter id : String | Int32 | Nil

    # Creates a new `Feature` with the given *geometry* and optional
    # *properties*, *id*, and bounding box *bbox*.
    def initialize(@geometry, @properties = nil, *, @id = nil, @bbox = nil)
    end
  end
end
