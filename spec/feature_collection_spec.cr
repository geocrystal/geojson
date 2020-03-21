require "./spec_helper"

describe GeoJSON::FeatureCollection do
  point_coordinates = [102.0, 0.5]

  multi_point_coordinates = [
    [100.0, 0.0],
    [101.0, 1.0],
  ]

  line_coordinates = [
    [102.0, 0.0],
    [103.0, 1.0],
    [104.0, 0.0],
    [105.0, 1.0],
  ]

  multi_line_string_coordinates = [
    [
      [100.0, 0.0],
      [101.0, 1.0],
    ],
    [
      [102.0, 2.0],
      [103.0, 3.0],
    ],
  ]

  polygon_coordinates = [
    [
      [100.0, 0.0],
      [101.0, 0.0],
      [101.0, 1.0],
      [100.0, 1.0],
      [100.0, 0.0],
    ],
  ]

  multi_poygon_coordinates = [
    [
      [
        [-10.0, -10.0],
        [10.0, -10.0],
        [10.0, 10.0],
        [-10.0, -10.0],
      ],
    ],
    [
      [
        [100.0, 0.0],
        [101.0, 0.0],
        [101.0, 1.0],
        [100.0, 1.0],
        [100.0, 0.0],
      ],
    ],
  ]

  feature_collection_json = {
    "type"     => "FeatureCollection",
    "features" => [
      {
        "type"     => "Feature",
        "geometry" => {
          "type"        => "Point",
          "coordinates" => point_coordinates,
        },
      },
      {
        "type"     => "Feature",
        "geometry" => {
          "type"      => "LineString",
          "coordinates": line_coordinates,
        },
        "properties" => {
          "prop0" => "value0",
          "prop1" => 0.0,
        },
      },
      {
        "type"     => "Feature",
        "geometry" => {
          "type"        => "Polygon",
          "coordinates" => polygon_coordinates,
        },
        "properties" => {
          "prop0" => "value0",
          "prop1" => {
            "this" => "that",
          },
        },
      },
      {
        "type"     => "Feature",
        "geometry" => {
          "type"        => "MultiPoint",
          "coordinates" => multi_point_coordinates,
        },
      },
      {
        "type"     => "Feature",
        "geometry" => {
          "type"        => "MultiLineString",
          "coordinates" => multi_line_string_coordinates,
        },
      },
      {
        "type"     => "Feature",
        "geometry" => {
          "type"        => "MultiPolygon",
          "coordinates" => multi_poygon_coordinates,
        },
      },
    ],
  }.to_json

  describe "json parser" do
    it "parses json" do
      feature_collection = GeoJSON::FeatureCollection.from_json(feature_collection_json)

      feature_collection.should be_a(GeoJSON::FeatureCollection)
      feature_collection.type.should eq("FeatureCollection")
      feature_collection.features.should be_a(Array(GeoJSON::Feature))
      feature_collection.features.size.should eq(6)

      feature_point = feature_collection.features[0]
      feature_point.should be_a(GeoJSON::Feature)
      feature_point.geometry.not_nil!.should be_a(GeoJSON::Point)
      point = feature_point.geometry.not_nil!
      point.as(GeoJSON::Point).longitude.should eq(102.0)

      feature_line_string = feature_collection.features[1]
      feature_line_string.should be_a(GeoJSON::Feature)
      feature_line_string.geometry.not_nil!.should be_a(GeoJSON::LineString)

      feature_polygon = feature_collection.features[2]
      feature_polygon.should be_a(GeoJSON::Feature)
      feature_polygon.geometry.not_nil!.should be_a(GeoJSON::Polygon)

      feature_multi_point = feature_collection.features[3]
      feature_multi_point.geometry.not_nil!.should be_a(GeoJSON::MultiPoint)

      feature_multi_line_string = feature_collection.features[4]
      feature_multi_line_string.geometry.not_nil!.should be_a(GeoJSON::MultiLineString)

      feature_multi_polygon = feature_collection.features[5]
      feature_multi_polygon.geometry.not_nil!.should be_a(GeoJSON::MultiPolygon)
    end
  end

  describe ".new" do
    it "initialize collection with features" do
      feature1 = GeoJSON::Feature.new(GeoJSON::Point.new(longitude: 1.0, latitude: 0.1))
      feature2 = GeoJSON::Feature.new(GeoJSON::Point.new(longitude: 0.1, latitude: 1.0))

      feature_collection = GeoJSON::FeatureCollection.new([feature1, feature2])

      feature_collection.should be_a(GeoJSON::FeatureCollection)
      feature_collection.features.first.should eq(feature1)
    end
  end

  describe "json object" do
    it "creates json object" do
      feature1 = GeoJSON::Feature.new(GeoJSON::Point.new(longitude: 1.0, latitude: 0.1))
      feature2 = GeoJSON::Feature.new(GeoJSON::Point.new(longitude: 0.1, latitude: 1.0))

      feature_collection = GeoJSON::FeatureCollection.new([feature1, feature2])

      feature_collection.to_json.should eq(
        "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[1.0,0.1]},\"properties\":null},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[0.1,1.0]},\"properties\":null}]}"
      )
    end
  end
end
