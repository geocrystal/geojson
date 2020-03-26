require "./spec_helper"

describe GeoJSON::Object do
  coordinates1 = [100.0, 0.0]
  coordinates2 = [101.0, 1.0]

  multi_point_json = {
    "type"        => "MultiPoint",
    "coordinates" => [coordinates1, coordinates2],
  }.to_json

  describe "json parser" do
    it "parses json" do
      object = GeoJSON::Object.from_json(multi_point_json)

      multi_point = object.should be_a(GeoJSON::MultiPoint)
      multi_point.type.should eq("MultiPoint")
      multi_point.coordinates.should be_a(Array(GeoJSON::Coordinates))
      multi_point[0].should be_a(GeoJSON::Coordinates)
      multi_point[0].latitude.should eq(0.0)
    end
  end
end
