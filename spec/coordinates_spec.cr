require "./spec_helper"

describe GeoJSON::Coordinates do
  it "raises an exception if coordinates are invalid" do
    expect_raises Exception, "GeoJSON::Coordinates must have two or three coordinates" do
      GeoJSON::Coordinates.new([1.0, 1.0, 1.0, 1.0])
    end
  end

  describe "==" do
    coordinates1 = GeoJSON::Coordinates.new([1.0, 1.0])
    coordinates2 = GeoJSON::Coordinates.new([-1.0, 1.0])
    coordinates3 = GeoJSON::Coordinates.new([1.0, 1.0])

    it { (coordinates1 == coordinates1).should be_truthy }
    it { (coordinates1 == coordinates2).should be_falsey }
    it { (coordinates1 == coordinates3).should be_truthy }
  end
end
