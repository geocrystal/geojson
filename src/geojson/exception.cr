module GeoJSON
  # Raised when an attempt is made to create a GeoJSON object that is malformed.
  #
  # In most cases, this means that the given coordinates for a geometry object
  # don't fulfill the requirements for that geometry type.
  class Exception < Exception
  end
end
