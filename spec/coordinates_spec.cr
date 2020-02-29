require "./spec_helper"

describe GeoJSON::Coordinates do
  it "raises an exception if coordinates are invalid" do
    expect_raises Exception, "GeoJSON::Coordinates must have two or three coordinates" do
      GeoJSON::Coordinates.new([1.0, 1.0, 1.0, 1.0])
    end
  end
end
