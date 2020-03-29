require "json"
require "./geojson/exception"
require "./geojson/object"
require "./geojson/coordinates"
require "./geojson/point"
require "./geojson/multi_point"
require "./geojson/line_string"
require "./geojson/multi_line_string"
require "./geojson/polygon"
require "./geojson/multi_polygon"
require "./geojson/geometry_collection"
require "./geojson/feature"
require "./geojson/feature_collection"

module GeoJSON
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end
