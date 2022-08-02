require "./spec_helper"

describe GeoJSON::Coordinates do
  it "raises an exception if coordinates are invalid" do
    expect_raises GeoJSON::Exception, "coordinates need to have have two or three elements" do
      GeoJSON::Coordinates.new([1.0, 1.0, 1.0, 1.0])
    end
  end

  context ".new" do
    it "with array" do
      coordinates = GeoJSON::Coordinates.new([0.1, 0.2, 0.3])

      coordinates.longitude.should eq(0.1)
      coordinates.latitude.should eq(0.2)
      coordinates.altitude.should eq(0.3)
    end

    it "with arguments" do
      coordinates = GeoJSON::Coordinates.new(0.1, 0.2, 0.3)

      coordinates.longitude.should eq(0.1)
      coordinates.latitude.should eq(0.2)
      coordinates.altitude.should eq(0.3)
    end

    it "with named arguments" do
      coordinates = GeoJSON::Coordinates.new(altitude: 0.3, latitude: 0.2, longitude: 0.1)

      coordinates.longitude.should eq(0.1)
      coordinates.latitude.should eq(0.2)
      coordinates.altitude.should eq(0.3)
    end
  end

  describe "json object" do
    it "creates json object" do
      coordinates = GeoJSON::Coordinates.new([0.1, 0.2, 0.3])

      coordinates.to_json.should eq("[0.1,0.2,0.3]")
    end
  end

  describe "==" do
    coordinates1 = GeoJSON::Coordinates.new([1.0, 1.0])
    coordinates2 = GeoJSON::Coordinates.new(1.0, 1.0)
    coordinates3 = GeoJSON::Coordinates.new(longitude: 1.0, latitude: 1.0)
    coordinates4 = GeoJSON::Coordinates.new(-1.0, 1.0)

    it { (coordinates1 == coordinates1).should be_truthy }
    it { (coordinates1 == coordinates2).should be_truthy }
    it { (coordinates1 == coordinates3).should be_truthy }
    it { (coordinates1 == coordinates4).should be_falsey }
  end
end
