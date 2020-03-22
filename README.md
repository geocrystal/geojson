# GeoJSON

[![Build Status](https://travis-ci.org/geocrystal/geo_json.svg?branch=master)](https://travis-ci.org/geocrystal/geo_json)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://geocrystal.github.io/geo_json/)
[![License](https://img.shields.io/github/license/geocrystal/geo_json.svg)](https://github.com/geocrystal/geo_json/blob/master/LICENSE)

Crystal library for reading and writing [GeoJSON](https://tools.ietf.org/html/rfc7946)

This library contains:

- Functions for encoding and decoding GeoJSON formatted data
- Classes for all GeoJSON Objects

## Installation

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  geo_json:
    github: geocrystal/geo_json
```

and run `shards install`

```crystal
require "geo_json"
```

## Position

A position is the fundamental geometry construct.  The `coordinates` member of a Geometry object is composed of either:

- one position in the case of a `Point` geometry
- an array of positions in the case of a `LineString` or `MultiPoint` geometry
- an array of `LineString` or linear ring coordinates in the case of a `Polygon` or `MultiLineString` geometry
- an array of `Polygon` coordinates in the case of a `MultiPolygon` geometry

A position is an array of `Float64`.

There __must__ be two or more elements. The first two elements are `longitude` and `latitude`. `Altitude` __may__ be included as an optional third element.

```crystal
postition = [-80.1347334, 25.7663562, 0.0]
point = GeoJSON::Point.new(position)
```

## GeoJSON types

### Point

A GeoJSON point looks like this:

```json
{
  "type": "Point",
  "coordinates": [-80.1347334, 25.7663562]
}
```

It is important to note that coordinates is in the format `[longitude, latitude]`.
Longitude comes before latitude in GeoJSON.

For type `Point`, the `coordinates` member is a single position.

Serialize geometry type:

```crystal
point = GeoJSON::Point.new([-80.1347334, 25.7663562])
json = point.to_json
# => {"type":"Point","coordinates":[-80.1347334,25.7663562]}
```

Deserialize geometry type:

```crystal
point = GeoJSON::Point.from_json(json)
# => #<GeoJSON::Point:0x7f1444af9920>
point.longitude
# => -80.1347334
point.latitude
# => 25.7663562
```

### MultiPoint

For type `MultiPoint`, the `coordinates` member is an array of positions.

```crystal
point1 = GeoJSON::Point.new(longitude: 100.0, latitude: 0.0)
point2 = GeoJSON::Point.new(longitude: 101.0, latitude: 1.0)

multi_point = GeoJSON::MultiPoint.new([point1, point2])
multi_point.json
```

```json
{
  "type":"MultiPoint",
  "coordinates":[[100.0, 0.0], [101.0, 1.0]]
}
```

### LineString

For type `LineString`, the `coordinates` member is an array of two or more positions.

```crystal
line_string = GeoJSON::LineString.new [[-124.2, 42.0], [-120.0, 42.0]]
line_string.to_json
```

```json
{
  "type": "LineString",
  "coordinates": [[-124.2, 42.0], [-120.0, 42.0]]
}
```

### MultiLineString

For type `MultiLineString`, the `coordinates` member is an array of `LineString` coordinate arrays.

```crystal
line_string1 = GeoJSON::LineString.new([[100.0, 0.0], [101.0, 1.0]])
line_string2 = GeoJSON::LineString.new([[102.0, 2.0], [103.0, 3.0]])

multi_line_string = GeoJSON::MultiLineString.new([line_string1, line_string2])
```

```crystal
multi_line_string = GeoJSON::MultiLineString.new([
  [[100.0, 0.0], [101.0, 1.0]],
  [[102.0, 2.0], [103.0, 3.0]],
])
multi_line_string.to_json
```

```json
{
  "type":"MultiLineString",
  "coordinates":[
    [
      [100.0, 0.0],
      [101.0, 1.0]
    ],
    [
      [102.0, 2.0],
      [103.0, 3.0]
    ]
  ]
}
```

### Polygon

GeoJSON polygons represent closed shapes on a map, like triangles, squares, dodecagons, or any shape with a fixed number of sides.

To specify a constraint specific to `Polygon`, it is useful to introduce the concept of a linear ring:

- A linear ring is a closed `LineString` with four or more positions.
- The first and last positions are equivalent, and they __must__ contain identical values; their representation __should__ also be identical.
- A linear ring is the boundary of a surface or the boundary of a hole in a surface.
- A linear ring __must__ follow the right-hand rule with respect to the area it bounds, i.e., exterior rings are counterclockwise, and holes are clockwise.

The `Polygon` geometry type definition as follows:

- For type `Polygon`, the `coordinates` member __must)) be an array of linear ring coordinate arrays.
- For `Polygon` with more than one of these rings, the first __must__ be the exterior ring, and any others __must__ be interior rings. The exterior ring bounds the surface, and the interior rings (if present) bound holes within the surface.

```crystal
polygon = GeoJSON::Polygon.new([
  [[-10.0, -10.0], [10.0, -10.0], [10.0, 10.0], [-10.0,-10.0]],
  [[-1.0, -2.0], [3.0, -2.0], [3.0, 2.0], [-1.0,-2.0]]
])
polygon.to_json
```

```json
{
  "type": "Polygon",
  "coordinates": [
    [
      [-10.0, -10.0],
      [10.0, -10.0],
      [10.0,10.0],
      [-10.0,-10.0]
    ],
    [
      [-1.0, -2.0],
      [3.0, -2.0],
      [3.0, 2.0],
      [-1.0,-2.0]
    ]
  ]
}
```

### MultiPolygon

For type `MultiPolygon`, the `coordinates` member is an array of `Polygon` coordinate arrays.

### GeometryCollection

A GeoJSON object with type `GeometryCollection` is a Geometry object.

A `GeometryCollection` has a member with the name `geometries`. The
value of `geometries` is an array. Each element of this array is a
GeoJSON Geometry object.

### Feature

### FeatureCollection

## Contributing

1. Fork it (<https://github.com/geocrystal/geo_json/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer

## License

Copyright: 2020 Anton Maminov (anton.maminov@gmail.com)

This library is distributed under the MIT license. Please see the LICENSE file.
