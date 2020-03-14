require "./spec_helper"

describe GeoJSON::MultiLineString do
  multi_line_string_json = {
    "type"        => "MultiLineString",
    "coordinates" => [
      [
        [100.0, 0.0],
        [101.0, 1.0],
      ],
      [
        [102.0, 2.0],
        [103.0, 3.0],
      ],
    ],
  }.to_json

  describe "json parser" do
    it "parses json" do
      multi_line_string = GeoJSON::MultiLineString.from_json(multi_line_string_json)

      multi_line_string.should be_a(GeoJSON::MultiLineString)
      multi_line_string.type.should eq("MultiLineString")
      multi_line_string.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))

      line_string = multi_line_string[0]
      line_string.should be_a(Array(GeoJSON::Coordinates))

      point = multi_line_string[0][0]
      point.should be_a(GeoJSON::Coordinates)
      point.latitude.should eq(0.0)
    end
  end

  describe ".new" do
    it "creates MultiLineString from array of LineString" do
      line_string1 = GeoJSON::LineString.new([
        GeoJSON::Point.new(longitude: 100.0, latitude: 0.0),
        GeoJSON::Point.new(longitude: 101.0, latitude: 1.0),
      ])
      line_string2 = GeoJSON::LineString.new([
        GeoJSON::Point.new(longitude: 102.0, latitude: 2.0),
        GeoJSON::Point.new(longitude: 103.0, latitude: 3.0),
      ])

      multi_line_string = GeoJSON::MultiLineString.new([line_string1, line_string2])

      multi_line_string.should be_a(GeoJSON::MultiLineString)
      multi_line_string.type.should eq("MultiLineString")
      multi_line_string.coordinates.should be_a((Array(Array(GeoJSON::Coordinates))))
      multi_line_string[0].should be_a((Array(GeoJSON::Coordinates)))

      multi_line_string.to_json.should eq(multi_line_string_json)
    end

    it "creates MultiPoint from array of coordinate arrays" do
      multi_line_string = GeoJSON::MultiLineString.new([
        [[100.0, 0.0], [101.0, 1.0]],
        [[102.0, 2.0], [103.0, 3.0]],
      ])

      multi_line_string.should be_a(GeoJSON::MultiLineString)
      multi_line_string.to_json.should eq(multi_line_string_json)
    end
  end

  describe ".<<" do
    it "appends LineString to coordinates" do
      multi_line_string = GeoJSON::MultiLineString.new([
        [[100.0, 0.0], [101.0, 1.0]],
      ])

      multi_line_string << [[102.0, 2.0], [103.0, 3.0]]

      multi_line_string.to_json.should eq(multi_line_string_json)
    end
  end
end
