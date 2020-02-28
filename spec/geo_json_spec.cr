require "./spec_helper"

describe GeoJSON do
  it "should have version" do
    GeoJSON::VERSION.should_not be_nil
  end
end
