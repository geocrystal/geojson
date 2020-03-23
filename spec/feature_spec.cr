require "./spec_helper"

describe GeoJSON::Feature do
  longitude = -80.1347334
  latitude = 25.7663562

  point_coordinates = [longitude, latitude]

  ring = [
    [100.0, 0.0],
    [101.0, 0.0],
    [101.0, 1.0],
    [100.0, 1.0],
    [100.0, 0.0],
  ]

  feature_point_json = {
    "type"     => "Feature",
    "geometry" => {
      "type"        => "Point",
      "coordinates" => point_coordinates,
    },
    "properties" => {
      "prop0" => "value0",
    },
  }.to_json

  feature_polygon_json = {
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
  }.to_json

  feature_with_foreign_members_json = {
    "type"     => "Feature",
    "geometry" => {
      "type"        => "Point",
      "coordinates" => point_coordinates,
    },
    "properties" => {
      "prop0" => "value0",
    },
    "title" => "Example Feature",
  }.to_json

  describe "json parser" do
    it "parses feture point json" do
      feature = GeoJSON::Feature.from_json(feature_point_json)

      feature.should be_a(GeoJSON::Feature)
      feature.type.should eq("Feature")
      feature.geometry.should be_a(GeoJSON::Point)
    end

    it "parses feature polygon json" do
      feature = GeoJSON::Feature.from_json(feature_polygon_json)

      feature.geometry.should be_a(GeoJSON::Polygon)
      polygon = feature.geometry.not_nil!.as(GeoJSON::Polygon)
      polygon.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))
    end

    it "parses feture with foreign json member" do
      feature = GeoJSON::Feature.from_json(feature_with_foreign_members_json)

      feature.should be_a(GeoJSON::Feature)
      feature.type.should eq("Feature")
      feature.json_unmapped["title"].should eq("Example Feature")
      feature.geometry.should be_a(GeoJSON::Point)
    end
  end

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
      geometry = GeoJSON::Point.new(point_coordinates)
      properties = {"color" => "red"} of String => JSON::Any::Type
      feature = GeoJSON::Feature.new(geometry, properties, id: 1)

      feature.geometry.should eq(geometry)
      feature.properties.should eq(properties)
      feature.id.should eq(1)
    end

    it "initialize Feature with foreign member" do
      geometry = GeoJSON::Point.new(point_coordinates)
      properties = {"prop0" => "value0"} of String => JSON::Any::Type

      json_unmapped = Hash(String, JSON::Any).new
      json_unmapped["title"] = JSON::Any.new("Example Feature")

      feature = GeoJSON::Feature.new(geometry, properties)
      feature.json_unmapped = json_unmapped

      feature.geometry.should eq(geometry)
      feature.to_json.should eq(feature_with_foreign_members_json)
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
