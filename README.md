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

### Polygon

### MultiPolygon

For type `MultiPolygon`, the `coordinates` member is an array of `Polygon` coordinate arrays.

### GeometryCollection

A GeoJSON object with type `GeometryCollection` is a Geometry object.

A `GeometryCollection` has a member with the name `geometries`. The
value of `geometries` is an array. Each element of this array is a
GeoJSON Geometry object.

### Feature

### FeatureCollection


TODO: Write usage instructions here

## Development

TODO: Write development instructions here

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
