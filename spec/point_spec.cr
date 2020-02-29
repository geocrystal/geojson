require "./spec_helper"

describe GeoJSON::Point do
  longitude = -80.1347334
  latitude = 25.7663562
  altitude = 0.0
  position = [longitude, latitude]
  position_with_alt = [longitude, latitude, altitude]

  point_json = {
    "type"        => "Point",
    "coordinates" => position,
  }.to_json

  point_with_alt_json = {
    "type"        => "Point",
    "coordinates" => position_with_alt,
  }.to_json

  invalid_point_json = {
    "type"        => "Point",
    "coordinates" => [1.0, 1.0, 1.0, 1.0],
  }.to_json

  describe "json parser" do
    it "parses json" do
      point = GeoJSON::Point.from_json(point_json)

      point.should be_a(GeoJSON::Point)
      point.type.should eq("Point")
      point.coordinates.should be_a(GeoJSON::Coordinates)
      point.longitude.should eq(longitude)
      point.latitude.should eq(latitude)
    end

    it "raises an exception if coordinates are invalid" do
      expect_raises Exception, "GeoJSON::Coordinates must have two or three coordinates" do
        GeoJSON::Point.from_json(invalid_point_json)
      end
    end
  end

  describe ".new" do
    it "creates Point" do
      point = GeoJSON::Point.new(longitude: longitude, latitude: latitude)

      point.should be_a(GeoJSON::Point)
      point.type.should eq("Point")
      point.coordinates.should be_a(GeoJSON::Coordinates)
      point.longitude.should eq(longitude)
      point.latitude.should eq(latitude)
      point.altitude.should be_nil

      point.to_json.should eq(point_json)
    end

    it "creates Point with altitude" do
      point = GeoJSON::Point.new(longitude: longitude, latitude: latitude, altitude: 0.0)

      point.should be_a(GeoJSON::Point)
      point.altitude.should eq(0.0)
      point.to_json.should eq(point_with_alt_json)
    end
  end
end
