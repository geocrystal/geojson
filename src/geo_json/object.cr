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
    alias Type = Point | MultiPoint | LineString | MultiLineString | Polygon | MultiPolygon

    alias CoordinatesArray = Array(Float64) | Array(CoordinatesArray)

    abstract def type : String

    def self.new(pull : JSON::PullParser)
      pull.read_begin_object

      until pull.kind.end_object?
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

      return unless coordinates

      case object_type
      when "Point"
        Point.new(coordinates.as(Array(Float64)))
      when "MultiPoint"
        coordinates = coordinates.map do |point|
          Point.new(point.as(Array(Float64)))
        end

        GeoJSON::MultiPoint.new(coordinates)
      when "LineString"
        coordinates = coordinates.map { |point| point.as(Array(Float64)).map(&.to_f) }

        GeoJSON::LineString.new(coordinates)
      when "MultiLineString"
        coordinates = coordinates.map do |line_string|
          LineString.new(
            line_string.as(Array(CoordinatesArray)).map { |point| point.as(Array(Float64)).map(&.to_f) }
          )
        end

        GeoJSON::MultiLineString.new(coordinates)
      when "Polygon"
        coordinates = coordinates.map do |ring|
          ring.as(Array(CoordinatesArray)).map do |point|
            point.as(Array(Float64)).map(&.to_f)
          end
        end

        GeoJSON::Polygon.new(coordinates)
      when "MultiPolygon"
        coordinates = coordinates.map do |polygon|
          Polygon.new(
            polygon.as(Array(CoordinatesArray)).map do |ring|
              ring.as(Array(CoordinatesArray)).map do |point|
                point.as(Array(Float64)).map(&.to_f)
              end
            end
          )
        end

        GeoJSON::MultiPolygon.new(coordinates)
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
  end
end
