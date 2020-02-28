module GeoJSON
  # https://tools.ietf.org/html/rfc7946#section-3.3
  class FeatureCollection < Object
    getter type : String = "FeatureCollection"

    getter features : Array(Feature)

    def initialize(@features : Array(Feature))
    end
  end
end
