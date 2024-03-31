module GeoJSON
  # A `FeatureCollection` represents a [GeoJSON FeatureCollection object](https://tools.ietf.org/html/rfc7946#section-3.3)
  # and contains one or more `Feature`s.
  class FeatureCollection < Object
    # Gets this FeatureCollection's GeoJSON type ("FeatureCollection")
    getter type : String = "FeatureCollection"

    # Returns this `FeatureCollections` array of features.
    getter features : Array(Feature)

    # Creates a new `FeatureCollection` with the given *features*.
    def initialize(@features : Array(Feature), *, @bbox = nil)
    end

    def bbox
      return @bbox if @bbox

      result = [Float64::INFINITY, Float64::INFINITY, -Float64::INFINITY, -Float64::INFINITY]

      features.each do |feature|
        feature.bbox.try do |feature_bbox|
          result[0] = feature_bbox[0] if result[0] > feature_bbox[0]
          result[1] = feature_bbox[1] if result[1] > feature_bbox[1]
          result[2] = feature_bbox[2] if result[2] < feature_bbox[2]
          result[3] = feature_bbox[3] if result[3] < feature_bbox[3]
        end
      end

      result
    end
  end
end
