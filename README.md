# GeoJSON

[![Build Status](https://travis-ci.org/geocrystal/geojson.svg?branch=master)](https://travis-ci.org/geocrystal/geojson)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://geocrystal.github.io/geojson/)
[![License](https://img.shields.io/github/license/geocrystal/geojson.svg)](https://github.com/geocrystal/geojson/blob/master/LICENSE)

Crystal library for reading and writing [GeoJSON](https://tools.ietf.org/html/rfc7946)

This library contains:

- Functions for encoding and decoding GeoJSON formatted data
- Classes for all GeoJSON Objects
- Allow "foreign members" in a GeoJSON Objects

## Installation

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  geojson:
    github: geocrystal/geojson
```

and run `shards install`

```crystal
require "geojson"
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

- For type `Polygon`, the `coordinates` member __must__ be an array of linear ring coordinate arrays.
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

```crystal
polygon1 = GeoJSON::Polygon.new(
  [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]]
)
polygon2 = GeoJSON::Polygon.new(
  [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]]]
)

multi_polygon = GeoJSON::MultiPolygon.new([polygon1, polygon2])
multi_polygon.to_json
```

```json
{
  "type":"MultiPolygon",
  "coordinates":[
    [
      [
        [102.0,2.0],
        [103.0,2.0],
        [103.0,3.0],
        [102.0,3.0],
        [102.0,2.0]
      ]
    ],
    [
      [
        [100.0,0.0],
        [101.0,0.0],
        [101.0,1.0],
        [100.0,1.0],
        [100.0,0.0]
      ]
    ]
  ]
}
```

### GeometryCollection

A GeoJSON object with type `GeometryCollection` is a Geometry object.

A `GeometryCollection` has a member with the name `geometries`. The
value of `geometries` is an array. Each element of this array is a
GeoJSON Geometry object.

```crystal
point = GeoJSON::Point.new([100.0, 0.0])
line_string = GeoJSON::LineString.new([
  [101.0, 0.0],
  [102.0, 1.0],
])
polygon = GeoJSON::Polygon.new([
  [
    [100.0, 0.0],
    [101.0, 0.0],
    [101.0, 1.0],
    [100.0, 1.0],
    [100.0, 0.0],
  ],
])

geometry_collection = GeoJSON::GeometryCollection.new([point, line_string, polygon])
geometry_collection.to_json
```

```json
{
  "type":"GeometryCollection",
  "geometries":[
    {
      "type":"Point",
      "coordinates":[100.0,0.0]
    },
    {
      "type":"LineString",
      "coordinates":[
        [101.0,0.0],
        [102.0,1.0]
      ]
    },
    {
      "type":"Polygon",
      "coordinates":[
        [
          [100.0,0.0],
          [101.0,0.0],
          [101.0,1.0],
          [100.0,1.0],
          [100.0,0.0]
        ]
      ]
    }
  ]
}
```

### Feature

A `Feature` object represents a spatially bounded thing. Every `Feature` object is a GeoJSON object no matter where it occurs in a GeoJSON text.

- A `Feature` object has a `"type"` member with the value `"Feature"`.
- A `Feature` object has a member with the name `"geometry"`. The value of the geometry member __shall__ be either a Geometry object as defined above or, in the case that the `Feature` is unlocated, a JSON `null` value.
- A `Feature` object has a member with the name `"properties"`. The value of the properties member is an object (any JSON object or a JSON `null` value).
- If a `Feature` has a commonly used identifier, that identifier __should__ be included as a member of the `Feature` object with the name `"id"`, and the value of this member is either a JSON string or number.

```crystal
point = GeoJSON::Point.new([-80.1347334, 25.7663562])
properties = {"color" => "red"} of String => JSON::Any::Type
feature = GeoJSON::Feature.new(point, properties, id: 1)
feature.to_json
```

```json
{
  "type":"Feature",
  "geometry":{
    "type":"Point",
    "coordinates":[-80.1347334,25.7663562]
  },
  "properties":{
    "color":"red"
  },
  "id":1
}
```

### FeatureCollection

A GeoJSON object with the type `"FeatureCollection"` is a `FeatureCollection` object. A `FeatureCollection` object has a member with the name `"features"`. The value of `"features"` is a JSON array. Each element of the array is a `Feature` object. It is possible for this array to be empty.

```crystal
feature1 = GeoJSON::Feature.new(
  GeoJSON::Point.new([102.0, 0.5]),
  id: "point"
)

feature2 = GeoJSON::Feature.new(
  GeoJSON::Polygon.new([
    [
      [100.0, 0.0],
      [101.0, 0.0],
      [101.0, 1.0],
      [100.0, 1.0],
      [100.0, 0.0],
    ],
  ]),
  type: "polygon"
)

feature_collection = GeoJSON::FeatureCollection.new([feature1, feature2])
feature_collection.to_json
```

```json
{
  "type":"FeatureCollection",
  "features":[
    {
      "type":"Feature",
      "geometry":{
        "type":"Point",
        "coordinates":[102.0,0.5]
      },
      "properties":null,
      "id":"point"
    },
    {
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[
          [
            [100.0,0.0],
            [101.0,0.0],
            [101.0,1.0],
            [100.0,1.0],
            [100.0,0.0]
          ]
        ]
      },
      "properties":null,
      "id":"polygon"
    }
  ]
}
```

## Foreign Members

For example, in the `Pont` object shown below

```json
{
  "type": "Point",
  "coordinates": [-80.1347334, 25.7663562],
  "title": "Example Point"
}
```

the name/value pair of `"title": "Example Point"` is a foreign member.

GeoJSON semantics do not apply to foreign members and their descendants, regardless of their names and values.

If the GeoJSON type include foreign members, this properties in the JSON document will be stored in a `Hash(String, JSON::Any)`.
On serialization, any keys inside `json_unmapped` will be serialized and appended to the current json object.

```crystal
point = GeoJSON::Point.new([-80.1347334, 25.7663562])

json_unmapped = Hash(String, JSON::Any).new
json_unmapped["title"] = JSON::Any.new("Example Point")

point.json_unmapped = json_unmapped
```

## Contributing

1. Fork it (<https://github.com/geocrystal/geojson/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer

## License

Copyright: 2020 Anton Maminov (anton.maminov@gmail.com)

This library is distributed under the MIT license. Please see the LICENSE file.
