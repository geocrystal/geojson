require "./spec_helper"

describe GeoJSON::Point do
  longitude = -80.1347334
  latitude = 25.7663562
  position = [longitude, latitude]

  point_json = {
    "type"        => "Point",
    "coordinates" => position,
  }.to_json

  it "parses json" do
    point = GeoJSON::Point.from_json(point_json)

    point.should be_a(GeoJSON::Point)
    point.type.should eq("Point")
    point.coordinates.should be_a(GeoJSON::Coordinates)
    point.longitude.should eq(longitude)
    point.latitude.should eq(latitude)
  end

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
