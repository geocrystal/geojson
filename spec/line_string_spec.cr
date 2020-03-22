require "./spec_helper"

describe GeoJSON::LineString do
  line_string_json = {
    "type"        => "LineString",
    "coordinates" => [
      [-170.0, 10.0],
      [170.0, 11.0],
    ],
  }.to_json

  describe "json parser" do
    it "parses json" do
      point = GeoJSON::LineString.from_json(line_string_json)

      point.should be_a(GeoJSON::LineString)
      point.type.should eq("LineString")
      point.coordinates.should be_a(Array(GeoJSON::Coordinates))
    end

    it "raises an exception if LineString is invalid" do
      expect_raises GeoJSON::Exception, "a line needs to have two or more coordinates to be valid" do
        GeoJSON::LineString.new([
          GeoJSON::Coordinates.new([-170.0, 10.0]),
        ])
      end
    end
  end

  describe ".new" do
    it "creates LineString from an array of Coordinates" do
      line_string = GeoJSON::LineString.new([
        GeoJSON::Coordinates.new([-170.0, 10.0]),
        GeoJSON::Coordinates.new([170.0, 10.0]),
      ])

      line_string.should be_a(GeoJSON::LineString)
      line_string.type.should eq("LineString")
      line_string.coordinates.should be_a(Array(GeoJSON::Coordinates))
    end

    it "creates LineString from an array of Point" do
      line_string = GeoJSON::LineString.new([
        GeoJSON::Point.new(longitude: -170.0, latitude: 10.0),
        GeoJSON::Point.new(longitude: 170.0, latitude: 10.0),
      ])

      line_string.should be_a(GeoJSON::LineString)
      line_string.type.should eq("LineString")
      line_string.coordinates.should be_a(Array(GeoJSON::Coordinates))
    end

    it "creates LineString from an array of coordinate arrays" do
      line_string = GeoJSON::LineString.new [[10.0, 15.0], [20.0, 25.0]]

      line_string.should be_a(GeoJSON::LineString)
      line_string.type.should eq("LineString")
      line_string.coordinates.should be_a(Array(GeoJSON::Coordinates))
      line_string[0].should eq(GeoJSON::Coordinates.new([10.0, 15.0]))
    end
  end

  describe "json object" do
    it "creates json object" do
      line_string = GeoJSON::LineString.new [[10.0, 15.0], [20.0, 25.0]]

      line_string.to_json.should eq(
        "{\"type\":\"LineString\",\"coordinates\":[[10.0,15.0],[20.0,25.0]]}"
      )
    end
  end
end
