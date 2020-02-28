require "./spec_helper"

describe GeoJSON::Feature do
  longitude = -80.1347334
  latitude = 25.7663562

  describe ".new" do
    it "initialize Feature with geometry" do
      geometry = GeoJSON::Point.new(longitude: longitude, latitude: latitude)
      feature = GeoJSON::Feature.new(geometry)

      feature.geometry.should eq(geometry)
      feature.properties.should be_nil
      feature.id.should be_nil
    end

    it "initialize Feature with geometry and properties" do
      geometry = GeoJSON::Point.new(longitude: longitude, latitude: latitude)
      properties = {"color" => "red"} of String => JSON::Any::Type
      feature = GeoJSON::Feature.new(geometry, properties)

      feature.geometry.should eq(geometry)
      feature.properties.should eq(properties)
      feature.id.should be_nil
    end

    it "initialize Feature with geometry and properties" do
      geometry = GeoJSON::Point.new(longitude: longitude, latitude: latitude)
      properties = {"color" => "red"} of String => JSON::Any::Type
      feature = GeoJSON::Feature.new(geometry, properties, id: 1)

      feature.geometry.should eq(geometry)
      feature.properties.should eq(properties)
      feature.id.should eq(1)
    end
  end

  describe "json object" do
    it "creates json object" do
      geometry = GeoJSON::Point.new(longitude: longitude, latitude: latitude)
      feature = GeoJSON::Feature.new(geometry)

      feature.to_json.should eq(
        "{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-80.1347334,25.7663562]},\"properties\":null}"
      )
    end

    it "creates json object with id" do
      geometry = GeoJSON::Point.new(longitude: longitude, latitude: latitude)
      feature = GeoJSON::Feature.new(geometry, id: 1)

      feature.to_json.should eq(
        "{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-80.1347334,25.7663562]},\"properties\":null,\"id\":1}"
      )
    end
  end
end
