require "./spec_helper"

describe GeoJSON do
  pt = GeoJSON::Point.new([102.0, 0.5])

  multi_pt = GeoJSON::MultiPoint.new([
    [102.0, 0.5],
    [103.0, 1.0],
  ])

  line = GeoJSON::LineString.new([
    [102.0, -10.0],
    [103.0, 1.0],
    [104.0, 0.0],
    [130.0, 4.0],
  ])

  poly = GeoJSON::Polygon.new([
    [
      [101.0, 0.0],
      [101.0, 1.0],
      [100.0, 1.0],
      [100.0, 0.0],
      [101.0, 0.0],
    ],
  ])

  multi_line = GeoJSON::MultiLineString.new([
    [
      [100.0, 0.0],
      [101.0, 1.0],
    ],
    [
      [102.0, 2.0],
      [103.0, 3.0],
    ],
  ])

  multi_poly = GeoJSON::MultiPolygon.new([
    [
      [
        [102.0, 2.0],
        [103.0, 2.0],
        [103.0, 3.0],
        [102.0, 3.0],
        [102.0, 2.0],
      ],
    ],
    [
      [
        [100.0, 0.0],
        [101.0, 0.0],
        [101.0, 1.0],
        [100.0, 1.0],
        [100.0, 0.0],
      ],
      [
        [100.2, 0.2],
        [100.8, 0.2],
        [100.8, 0.8],
        [100.2, 0.8],
        [100.2, 0.2],
      ],
    ],
  ])

  geometry_collection = GeoJSON::GeometryCollection.new([pt, line, poly, multi_line, multi_poly])

  feature = GeoJSON::Feature.new(poly)

  pt_feature = GeoJSON::Feature.new(pt)
  line_feature = GeoJSON::Feature.new(line)
  poly_feature = GeoJSON::Feature.new(poly)
  multi_line_feature = GeoJSON::Feature.new(multi_line)
  multi_poly_feature = GeoJSON::Feature.new(multi_poly)

  feature_collection = GeoJSON::FeatureCollection.new([
    pt_feature,
    line_feature,
    poly_feature,
    multi_line_feature,
    multi_poly_feature,
  ])

  context ".bbox" do
    it { pt.bbox.should eq([102, 0.5, 102, 0.5]) }
    it { multi_pt.bbox.should eq([102.0, 0.5, 103.0, 1.0]) }
    it { line.bbox.should eq([102, -10, 130, 4]) }
    it { poly.bbox.should eq([100, 0, 101, 1]) }
    it { multi_line.bbox.should eq([100, 0, 103, 3]) }
    it { multi_poly.bbox.should eq([100, 0, 103, 3]) }
    it { geometry_collection.bbox.should eq([100, -10, 130, 4]) }
    it { feature.bbox.should eq([100, 0, 101, 1]) }
    it { feature_collection.bbox.should eq([100, -10, 130, 4]) }
  end
end
