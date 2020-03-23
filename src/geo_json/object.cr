module GeoJSON
  # GeoJSON Object
  #
  # A GeoJSON object represents a Geometry, Feature, or collection of Features.
  #
  # * A GeoJSON object is a JSON object.
  # * A GeoJSON object has a member with the name "type". The value of
  #   the member MUST be one of the GeoJSON types.
  #   `Point`, `MultiPoint`, `LineString`, `MultiLineString`, `Polygon`, `MultiPolygon`,
  #   `GeometryCollection`, `Feature`, and `FeatureCollection`
  # * A GeoJSON object MAY have a "bbox" member, the value of which MUST
  #   be a bounding box array
  # * A GeoJSON object MAY have other members
  abstract class Object
    include JSON::Serializable
    include JSON::Serializable::Unmapped

    # All possible GeoJSON types.
    alias Type = Point | MultiPoint | LineString | MultiLineString | Polygon | MultiPolygon

    alias CoordinatesArray = Array(Float64) | Array(CoordinatesArray)

    abstract def type : String

    def self.new(pull : JSON::PullParser)
      object_type, coordinates = parse_object(pull)

      return unless coordinates

      create_object(object_type, coordinates)
    end

    private def self.parse_object(pull)
      pull.read_begin_object

      until pull.kind.end_object?
        case pull.read_string
        when "type"
          object_type = pull.read_string
        when "coordinates"
          coordinates = recursive_array(pull)
        else
          pull.read_next
        end
      end

      pull.read_end_object

      {object_type, coordinates}
    end

    private def self.create_object(object_type, coordinates)
      case object_type
      when "Point"
        point(coordinates)
      when "MultiPoint"
        multi_point(coordinates)
      when "LineString"
        line_string(coordinates)
      when "MultiLineString"
        multi_line_string(coordinates)
      when "Polygon"
        polygon(coordinates)
      when "MultiPolygon"
        multi_polygon(coordinates)
      else
        nil
      end
    end

    # I am not sure why this works but it fixes the problem.
    # You are not meant to understand this.
    private def self.recursive_array(pull)
      ary = [] of CoordinatesArray
      coordinates = [] of Float64

      pull.read_begin_array

      until pull.kind.end_array?
        if pull.kind.begin_array?
          ary << recursive_array(pull)
        elsif pull.kind.float?
          coordinates << pull.read_float
        end
      end

      pull.read_end_array

      ary.empty? ? coordinates : ary
    end

    private def self.point(coordinates) : Point
      Point.new(coordinates.as(Array(Float64)))
    end

    private def self.multi_point(coordinates) : MultiPoint
      points = coordinates.map do |point|
        point(point)
      end

      GeoJSON::MultiPoint.new(points)
    end

    private def self.line_string(coordinates) : LineString
      coordinates = coordinates.map { |point| point.as(Array(Float64)).map(&.to_f) }

      GeoJSON::LineString.new(coordinates)
    end

    private def self.multi_line_string(coordinates) : MultiLineString
      line_strings = coordinates.map do |line_string|
        line_string(line_string.as(Array(CoordinatesArray)))
      end

      GeoJSON::MultiLineString.new(line_strings)
    end

    private def self.polygon(coordinates) : Polygon
      rings = coordinates.map do |ring|
        ring.as(Array(CoordinatesArray)).map do |point|
          point.as(Array(Float64)).map(&.to_f)
        end
      end

      GeoJSON::Polygon.new(rings)
    end

    private def self.multi_polygon(coordinates) : MultiPolygon
      polygons = coordinates.map do |polygon|
        polygon(polygon.as(Array(CoordinatesArray)))
      end

      GeoJSON::MultiPolygon.new(polygons)
    end
  end
end
