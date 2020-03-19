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

    # All possible GeoJSON types.
    alias Type = Point | MultiPoint | LineString | MultiLineString | Polygon | MultiPolygon | Feature | FeatureCollection

    alias CoordinatesArray = Array(Float64) | Array(CoordinatesArray)

    abstract def type : String

    def self.recursive_array(pull)
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

    def self.new(pull : JSON::PullParser)
      pull.read_begin_object

      while !pull.kind.end_object?
        case pull.read_string
        when "type"
          object_type = pull.read_string
        when "coordinates"
          coordinates = recursive_array(pull)
        when "geometry"
          new(pull)
        else
          pull.read_next
        end
      end

      pull.read_end_object

      case object_type
      when "Point"
        if coordinates
          return Point.new(coordinates.as(Array(Float64)))
        end
      when "LineString"
        if coordinates
          coordinates = coordinates.map { |c| c.as(Array(Float64)).map(&.to_f) }

          return GeoJSON::LineString.new(coordinates)
        end
      when "Polygon"
        if coordinates
          coordinates = coordinates.map do |ring|
            ring.as(Array(CoordinatesArray)).map do |point|
              point.as(Array(Float64)).map(&.to_f)
            end
          end

          return GeoJSON::Polygon.new(coordinates)
        end
      end

      nil
    end
  end
end
