require "./spec_helper"

describe GeoJSON::MultiPoint do
  coordinates1 = [100.0, 0.0]
  coordinates2 = [101.0, 1.0]

  multi_point_json = {
    "type"        => "MultiPoint",
    "coordinates" => [coordinates1, coordinates2],
  }.to_json

  describe "json parser" do
    it "parses json" do
      multi_point = GeoJSON::MultiPoint.from_json(multi_point_json)

      multi_point.should be_a(GeoJSON::MultiPoint)
      multi_point.type.should eq("MultiPoint")
      multi_point.coordinates.should be_a(Array(GeoJSON::Coordinates))
      multi_point[0].should be_a(GeoJSON::Coordinates)
      multi_point[0].latitude.should eq(0.0)
    end
  end

  describe ".new" do
    it "creates MultiPoint from array of Point" do
      point1 = GeoJSON::Point.new(longitude: 100.0, latitude: 0.0)
      point2 = GeoJSON::Point.new(longitude: 101.0, latitude: 1.0)
      multi_point = GeoJSON::MultiPoint.new([point1, point2])

      puts multi_point.to_json

      multi_point.should be_a(GeoJSON::MultiPoint)
      multi_point.type.should eq("MultiPoint")
      multi_point[0].should be_a(GeoJSON::Coordinates)
      multi_point[0].latitude.should eq(0.0)

      multi_point.to_json.should eq(multi_point_json)
    end

    it "creates MultiPoint from array of coordinate arrays" do
      multi_point = GeoJSON::MultiPoint.new([coordinates1, coordinates2])

      multi_point.should be_a(GeoJSON::MultiPoint)
      multi_point.type.should eq("MultiPoint")
      multi_point.coordinates.should be_a(Array(GeoJSON::Coordinates))
      multi_point[0].latitude.should eq(0.0)

      multi_point.to_json.should eq(multi_point_json)
    end
  end

  describe ".<<" do
    it "appends Point to coordinates" do
      multi_point = GeoJSON::MultiPoint.new([coordinates1])
      multi_point << coordinates2

      multi_point.to_json.should eq(multi_point_json)
      multi_point.coordinates[1].latitude.should eq(1.0)
    end
  end
end
