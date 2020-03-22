require "./spec_helper"

describe GeoJSON::Point do
  longitude = -80.1347334
  latitude = 25.7663562
  altitude = 0.0
  position = [longitude, latitude]
  position_with_alt = [longitude, latitude, altitude]
  invalid_position = [1.0, 1.0, 1.0, 1.0]

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
    "coordinates" => invalid_position,
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
      expect_raises GeoJSON::Exception, "coordinates need to have have two or three elements" do
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

    it "creates Point from Coordinates" do
      coordinates = GeoJSON::Coordinates.new(position)
      point = GeoJSON::Point.new(coordinates)

      point.should be_a(GeoJSON::Point)
      point.type.should eq("Point")
      point.coordinates.should be_a(GeoJSON::Coordinates)
      point.longitude.should eq(longitude)
      point.latitude.should eq(latitude)
      point.altitude.should be_nil

      point.to_json.should eq(point_json)
    end

    it "creates Point from an array" do
      point = GeoJSON::Point.new(position)

      point.should be_a(GeoJSON::Point)
      point.type.should eq("Point")
      point.coordinates.should be_a(GeoJSON::Coordinates)
      point.longitude.should eq(longitude)
      point.latitude.should eq(latitude)
      point.altitude.should be_nil

      point.to_json.should eq(point_json)
    end

    it "raises an exception if coordinates are invalid" do
      expect_raises GeoJSON::Exception, "coordinates need to have have two or three elements" do
        GeoJSON::Point.new(invalid_position)
      end
    end
  end

  describe "json object" do
    it "creates json object" do
      point = GeoJSON::Point.new(longitude: longitude, latitude: latitude)

      point.to_json.should eq(point_json)
    end
  end

  describe "==" do
    point1 = GeoJSON::Point.new(longitude: 1.0, latitude: 1.0)
    point2 = GeoJSON::Point.new(longitude: -1.0, latitude: 1.0)
    point3 = GeoJSON::Point.new(longitude: 1.0, latitude: 1.0)

    it { (point1 == point1).should be_truthy }
    it { (point1 == point2).should be_falsey }
    it { (point1 == point3).should be_truthy }
  end
end
