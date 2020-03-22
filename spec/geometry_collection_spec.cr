require "./spec_helper"

describe GeoJSON::GeometryCollection do
  point_coordinates = [100.0, 0.0]

  line_string_coordinates = [
    [101.0, 0.0],
    [102.0, 1.0],
  ]

  polygon_coordinates = [
    [
      [100.0, 0.0],
      [101.0, 0.0],
      [101.0, 1.0],
      [100.0, 1.0],
      [100.0, 0.0],
    ],
  ]

  geometry_collection_json = {
    "type"       => "GeometryCollection",
    "geometries" => [
      {
        "type"        => "Point",
        "coordinates" => point_coordinates,
      },
      {
        "type"        => "LineString",
        "coordinates" => line_string_coordinates,
      },
      {
        "type"        => "Polygon",
        "coordinates" => polygon_coordinates,
      },
    ],
  }.to_json

  describe "json parser" do
    it "parses json" do
      geometry_collection = GeoJSON::GeometryCollection.from_json(geometry_collection_json)
      geometry_collection.should be_a(GeoJSON::GeometryCollection)
      geometry_collection.geometries.should be_a(Array(GeoJSON::Object::Type))
      geometry_collection.geometries.size.should eq(3)

      point = geometry_collection.geometries[0]
      point.should be_a(GeoJSON::Point)

      line_string = geometry_collection.geometries[1]
      line_string.should be_a(GeoJSON::LineString)

      polygon = geometry_collection.geometries[2]
      polygon.should be_a(GeoJSON::Polygon)
    end
  end

  describe ".new" do
    it "initialize collection with geomertirs" do
      point = GeoJSON::Point.new(point_coordinates)
      line_string = GeoJSON::LineString.new(line_string_coordinates)
      polygon = GeoJSON::Polygon.new(polygon_coordinates)

      geometry_collection = GeoJSON::GeometryCollection.new([point, line_string, polygon])

      geometry_collection.should be_a(GeoJSON::GeometryCollection)
      geometry_collection.geometries[0].should be_a(GeoJSON::Point)
      geometry_collection.geometries[1].should be_a(GeoJSON::LineString)
      geometry_collection.geometries[2].should be_a(GeoJSON::Polygon)
      geometry_collection.to_json.should eq(geometry_collection_json)
    end
  end
end
