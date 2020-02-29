require "./spec_helper"

describe GeoJSON::Point do
  longitude = -80.1347334
  latitude = 25.7663562
  position = [longitude, latitude]

  point_json = {
    "type"        => "Point",
    "coordinates" => position,
  }.to_json

  invalid_point_json = {
    "type"        => "Point",
    "coordinates" => [1.0, 1.0, 1.0],
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
      expect_raises Exception, "GeoJSON::Coordinates must have two coordinates" do
        GeoJSON::Point.from_json(invalid_point_json)
      end
    end
  end

  describe ".new" do
    it "creates object" do
      point = GeoJSON::Point.new(longitude: longitude, latitude: latitude)

      point.should be_a(GeoJSON::Point)
      point.type.should eq("Point")
      point.coordinates.should be_a(GeoJSON::Coordinates)
      point.longitude.should eq(longitude)
      point.latitude.should eq(latitude)

      point.to_json.should eq(point_json)
    end
  end
end
