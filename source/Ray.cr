require "./V4"
require "./Matrices"
require "./Sphere"
require "./Intersection"

module Tracer
  class Ray
    property origin : V4
    property direction : V4

    def initialize(@origin : V4, @direction : V4)
    end

    def position(distance : Float64) : V4
      @origin + (@direction * distance)
    end

    def transform(matrix : M4x4) : Ray
      Ray.new matrix * @origin, matrix * @direction
    end
  end
end
