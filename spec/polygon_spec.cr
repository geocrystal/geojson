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

  polygon_json = {
    "type"        => "Polygon",
    "coordinates" => [exterior_ring, interior_ring],
  }.to_json

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
      polygon = GeoJSON::Polygon.new([exterior_ring_coordinates])

      polygon.should be_a(GeoJSON::Polygon)
      polygon.type.should eq("Polygon")
      polygon.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))
    end

    it "creates Polygon from an array of Point" do
      polygon = GeoJSON::Polygon.new([exterior_ring_points])

      polygon.should be_a(GeoJSON::Polygon)
      polygon.type.should eq("Polygon")
      polygon.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))
    end

    it "creates Polygon from an array of coordinate arrays" do
      polygon = GeoJSON::Polygon.new([exterior_ring])

      polygon.should be_a(GeoJSON::Polygon)
      polygon.type.should eq("Polygon")
      polygon.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))
    end

    it "creates Polygon with the exterior ring and hole" do
      polygon = GeoJSON::Polygon.new([exterior_ring, interior_ring])

      polygon.should be_a(GeoJSON::Polygon)
      polygon.type.should eq("Polygon")
      polygon.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))
      polygon.coordinates.size.should eq(2)
    end

    context "exceptions" do
      it "raise an error if empty" do
        expect_raises GeoJSON::Exception, "a coordinate array should have been found" do
          GeoJSON::Polygon.new([] of Array(GeoJSON::Coordinates))
        end
      end

      it "raise an error if have less then four positions" do
        ring = [
          [-10.0, -10.0],
          [10.0, -10.0],
          [-10.0, -10.0],
        ]

        expect_raises GeoJSON::Exception, "a LinearRing of coordinates needs to have four or more positions" do
          GeoJSON::Polygon.new([ring])
        end
      end

      it "raise an error unless first and last positions are the same" do
        ring = [
          [-10.0, -10.0],
          [10.0, -10.0],
          [10.0, 10.0],
          [-10.0, -10.1],
        ]

        expect_raises GeoJSON::Exception, "the first and last positions in a LinearRing of coordinates must be the same" do
          GeoJSON::Polygon.new([ring])
        end
      end
    end
  end

  describe "json parser" do
    it "parses json" do
      point = GeoJSON::Polygon.from_json(polygon_json)

      point.should be_a(GeoJSON::Polygon)
      point.type.should eq("Polygon")
      point.coordinates.should be_a(Array(Array(GeoJSON::Coordinates)))
    end
  end

  describe "json object" do
    it "creates json object" do
      polygon = GeoJSON::Polygon.new([exterior_ring_points])

      polygon.to_json.should eq(polygon_json)
    end
  end
end
