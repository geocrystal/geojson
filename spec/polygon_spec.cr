require "./spec_helper"

describe GeoJSON::Polygon do
  exterior_ring = [
    [-10.0, -10.0],
    [10.0, -10.0],
    [10.0, 10.0],
    [-10.0, -10.0],
  ]

  interior_ring = [
    [100.8, 0.8],
    [100.8, 0.2],
    [100.2, 0.2],
    [100.2, 0.8],
    [100.8, 0.8],
  ]

  exterior_ring_coordinates = exterior_ring.map do |e|
    GeoJSON::Coordinates.new(e)
  end

  exterior_ring_points = exterior_ring.map do |e|
    GeoJSON::Point.new(e)
  end

  polygon_json = {
    "type"        => "Polygon",
    "coordinates" => [exterior_ring],
  }.to_json

  describe ".new" do
    it "creates Polygon from an array of Coordinates" do
      line_string = GeoJSON::Polygon.new([exterior_ring_coordinates])

      line_string.should be_a(GeoJSON::Polygon)
      line_string.type.should eq("Polygon")
      line_string.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))
    end

    it "creates Polygon from an array of Point" do
      line_string = GeoJSON::Polygon.new([exterior_ring_points])

      line_string.should be_a(GeoJSON::Polygon)
      line_string.type.should eq("Polygon")
      line_string.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))
    end

    it "creates Polygon from an array of coordinate arrays" do
      line_string = GeoJSON::Polygon.new([exterior_ring])

      line_string.should be_a(GeoJSON::Polygon)
      line_string.type.should eq("Polygon")
      line_string.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))
    end

    it "creates Polygon with the exterior ring and hole" do
      line_string = GeoJSON::Polygon.new([exterior_ring, interior_ring])

      line_string.should be_a(GeoJSON::Polygon)
      line_string.type.should eq("Polygon")
      line_string.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))
      line_string.coordinates.size.should eq(2)
    end
  end

  describe "json parser" do
    it "parses json" do
      point = GeoJSON::Polygon.from_json(polygon_json)

      point.should be_a(GeoJSON::Polygon)
      point.type.should eq("Polygon")
      point.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))
    end

    it "raises an exception if LineString is invalid" do
      expect_raises Exception, "GeoJSON::LineString must have two or more points" do
        line_string = GeoJSON::LineString.new([
          GeoJSON::Coordinates.new([-170.0, 10.0]),
        ])
      end
    end
  end

  describe "json object" do
    it "creates json object" do
      polygon = GeoJSON::Polygon.new([exterior_ring_points])

      polygon.to_json.should eq(
        "{\"type\":\"Polygon\",\"coordinates\":[[[-10.0,-10.0],[10.0,-10.0],[10.0,10.0],[-10.0,-10.0]]]}"
      )
    end
  end
end
