require "./spec_helper"

describe GeoJSON::MultiLineString do
  multi_line_string_json = {
    "type"        => "MultiLineString",
    "coordinates" => [
      {
        "type"        => "LineString",
        "coordinates" => [
          [-170.0, 10.0],
          [170.0, 11.0],
        ],
      },
      {
        "type"        => "LineString",
        "coordinates" => [
          [-17.0, 1.0],
          [17.0, 1.1],
        ],
      },
    ],
  }.to_json

  describe "json parser" do
    it "parses json" do
      multi_line_string = GeoJSON::MultiLineString.from_json(multi_line_string_json)

      multi_line_string.should be_a(GeoJSON::MultiLineString)
      multi_line_string.type.should eq("MultiLineString")
      multi_line_string.coordinates.should be_a(Array(GeoJSON::LineString))

      line_string = multi_line_string[0]
      line_string.should be_a(GeoJSON::LineString)

      point = multi_line_string[0][0]
      point.should be_a(GeoJSON::Coordinates)
      point.latitude.should eq(10.0)
    end
  end

  describe ".new" do
    it "creates MultiLineString from array of LineString" do
      line_string1 = GeoJSON::LineString.new([
        GeoJSON::Point.new(longitude: -170.0, latitude: 10.0),
        GeoJSON::Point.new(longitude: 170.0, latitude: 11.0),
      ])
      line_string2 = GeoJSON::LineString.new([
        GeoJSON::Point.new(longitude: -17.0, latitude: 1.0),
        GeoJSON::Point.new(longitude: 17.0, latitude: 1.1),
      ])

      multi_line_string = GeoJSON::MultiLineString.new([line_string1, line_string2])

      multi_line_string.should be_a(GeoJSON::MultiLineString)
      multi_line_string.type.should eq("MultiLineString")
      multi_line_string.coordinates.should be_a(Array(GeoJSON::LineString))
      multi_line_string[0].should be_a(GeoJSON::LineString)

      multi_line_string.to_json.should eq(multi_line_string_json)
    end

    it "creates MultiPoint from array of coordinate arrays" do
      multi_line_string = GeoJSON::MultiLineString.new([
        [[-170.0, 10.0], [170.0, 11.0]],
        [[-17.0, 1.0], [17.0, 1.1]],
      ])

      multi_line_string.should be_a(GeoJSON::MultiLineString)
      multi_line_string.to_json.should eq(multi_line_string_json)
    end
  end

  describe ".<<" do
    it "appends LineString to coordinates" do
      multi_line_string = GeoJSON::MultiLineString.new([
        [[-170.0, 10.0], [170.0, 11.0]],
      ])

      multi_line_string << [[-17.0, 1.0], [17.0, 1.1]]

      multi_line_string.to_json.should eq(multi_line_string_json)
    end
  end
end
