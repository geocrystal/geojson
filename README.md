# GeoJSON

[![Build Status](https://travis-ci.org/geocrystal/geo_json.svg?branch=master)](https://travis-ci.org/geocrystal/geo_json)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://geocrystal.github.io/geo_json/)
[![License](https://img.shields.io/github/license/geocrystal/geo_json.svg)](https://github.com/geocrystal/geo_json/blob/master/LICENSE)

The [GeoJSON](https://tools.ietf.org/html/rfc7946) Format for Crystal

## GeoJSON types

- [x] Point
- [ ] MultiPoint
- [x] LineString
- [ ] MultiLineString
- [x] Polygon
- [ ] MultiPolygon
- [ ] GeometryCollection
- [x] Feature
- [x] FeatureCollection

## Installation

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  geo_json:
    github: geocrystal/geo_json
```

and run `shards install`

## Usage

```crystal
require "geo_json"
```

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
