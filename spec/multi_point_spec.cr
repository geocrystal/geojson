require "./spec_helper"

describe GeoJSON::MultiPoint do
  multi_point_json = {
    "type"        => "MultiPoint",
    "coordinates" => [
      {
        "type"        => "Point",
        "coordinates" => [-1.1, -1.1],
      },
      {
        "type"        => "Point",
        "coordinates" => [1.1, 1.1],
      },
    ],
  }.to_json

  describe "json parser" do
    it "parses json" do
      multi_point = GeoJSON::MultiPoint.from_json(multi_point_json)

      multi_point.should be_a(GeoJSON::MultiPoint)
      multi_point.type.should eq("MultiPoint")
      multi_point.coordinates.should be_a(Array(GeoJSON::Point))
      multi_point[0].should be_a(GeoJSON::Point)
      multi_point[0].latitude.should eq(-1.1)
    end
  end

  describe ".new" do
    it "creates MultiPoint from array of Point" do
      point1 = GeoJSON::Point.new(longitude: -1.1, latitude: -1.1)
      point2 = GeoJSON::Point.new(longitude: 1.1, latitude: 1.1)
      multi_point = GeoJSON::MultiPoint.new([point1, point2])

      multi_point.should be_a(GeoJSON::MultiPoint)
      multi_point.type.should eq("MultiPoint")
      multi_point.coordinates.should be_a(Array(GeoJSON::Point))
      multi_point[0].should be_a(GeoJSON::Point)
      multi_point[0].latitude.should eq(-1.1)

      multi_point.to_json.should eq(multi_point_json)
    end

    it "creates MultiPoint from array of coordinate arrays" do
      multi_point = GeoJSON::MultiPoint.new([[-1.1, -1.1], [1.1, 1.1]])

      multi_point.should be_a(GeoJSON::MultiPoint)
      multi_point.type.should eq("MultiPoint")
      multi_point.coordinates.should be_a(Array(GeoJSON::Point))
      multi_point[0].should be_a(GeoJSON::Point)
      multi_point[0].latitude.should eq(-1.1)

      multi_point.to_json.should eq(multi_point_json)
    end
  end

  describe ".<<" do
    it "appends Point to coordinates" do
      multi_point = GeoJSON::MultiPoint.new([[-1.1, -1.1]])
      multi_point << [1.1, 1.1]

      multi_point.to_json.should eq(multi_point_json)
      multi_point.coordinates[1].latitude.should eq(1.1)
    end
  end
end
