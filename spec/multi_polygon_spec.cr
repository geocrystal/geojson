require "./spec_helper"

describe GeoJSON::MultiPolygon do
  ring1 = [
    [
      [102.0, 2.0],
      [103.0, 2.0],
      [103.0, 3.0],
      [102.0, 3.0],
      [102.0, 2.0],
    ],
  ]

  ring2 = [
    [
      [100.0, 0.0],
      [101.0, 0.0],
      [101.0, 1.0],
      [100.0, 1.0],
      [100.0, 0.0],
    ],
  ]

  multi_polygon_json = {
    "type"        => "MultiPolygon",
    "coordinates" => [ring1, ring2],
  }.to_json

  describe "json parser" do
    it "parses json" do
      multi_polygon = GeoJSON::MultiPolygon.from_json(multi_polygon_json)

      multi_polygon.should be_a(GeoJSON::MultiPolygon)
      multi_polygon.type.should eq("MultiPolygon")
      multi_polygon.coordinates.should be_a(Array(Array(Array(GeoJSON::Coordinates))))

      polygon = multi_polygon[0]
      polygon.should be_a(Array(Array(GeoJSON::Coordinates)))
    end
  end

  describe ".new" do
    it "creates MultiPolygon from array of Polygon" do
      polygon1 = GeoJSON::Polygon.new(ring1)
      polygon2 = GeoJSON::Polygon.new(ring2)

      multi_polygon = GeoJSON::MultiPolygon.new([polygon1, polygon2])

      multi_polygon.should be_a(GeoJSON::MultiPolygon)
      multi_polygon.type.should eq("MultiPolygon")
      multi_polygon.coordinates.should be_a(Array(Array(Array(GeoJSON::Coordinates))))

      multi_polygon.to_json.should eq(multi_polygon_json)
    end

    it "creates MultiPolygon from array of coordinate arrays" do
      multi_polygon = GeoJSON::MultiPolygon.new([ring1, ring2])

      multi_polygon.should be_a(GeoJSON::MultiPolygon)
      multi_polygon.to_json.should eq(multi_polygon_json)
    end
  end

  describe ".<<" do
    it "appends Polygon to coordinates" do
      multi_polygon = GeoJSON::MultiPolygon.new([ring1])

      multi_polygon << ring2

      multi_polygon.to_json.should eq(multi_polygon_json)
    end
  end
end
