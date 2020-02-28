require "./spec_helper"

describe GeoJSON::FeatureCollection do
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
