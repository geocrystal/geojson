require "./spec_helper"

describe GeoJSON::FeatureCollection do
  point_coordinates = [102.0, 0.5]
  line_coordinates = [
    [102.0, 0.0],
    [103.0, 1.0],
    [104.0, 0.0],
    [105.0, 1.0],
  ]
  ring = [
    [100.0, 0.0],
    [101.0, 0.0],
    [101.0, 1.0],
    [100.0, 1.0],
    [100.0, 0.0],
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
          "coordinates" => [ring],
        },
        "properties" => {
          "prop0" => "value0",
          "prop1" => {
            "this" => "that",
          },
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
      feature_collection.features.size.should eq(3)

      feature1 = feature_collection.features[0]
      feature1.should be_a(GeoJSON::Feature)
      feature1.geometry.not_nil!.should be_a(GeoJSON::Point)
      point = feature1.geometry.not_nil!
      point.as(GeoJSON::Point).longitude.should eq(102.0)

      feature2 = feature_collection.features[1]
      feature2.should be_a(GeoJSON::Feature)
      feature2.geometry.not_nil!.should be_a(GeoJSON::LineString)

      feature3 = feature_collection.features[2]
      feature3.should be_a(GeoJSON::Feature)
      feature3.geometry.not_nil!.should be_a(GeoJSON::Polygon)
    end
  end

  describe ".new" do
    it "initialize Feature with geometry" do
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
