require "./Solid"
require "./Solid"
require "./V4"
require "./Ray"

module Tracer
  class Intersection
    property distance : Float64
    property solid : Solid

    def initialize(@distance : Float64, @solid : Solid)
    end

    def self.hit(intersections : Array(Intersection)) : Intersection|Nil
      return nil unless intersections.size

      lowest_nn = Float64::MAX
      lowest_nn_idx = -1
      intersections.each_with_index do |inter, index|
        next if inter.distance < 0.0
        next if inter.distance > lowest_nn
        lowest_nn = inter.distance
        lowest_nn_idx = index
      end

      return nil unless (lowest_nn_idx > -1)
      return intersections[lowest_nn_idx]
    end
  end

  class RayIntersection
    property distance  : Float64
    property solid     : Solid
    property position  : Point
    property eye_v     : Vector
    property normal_v  : Vector
    property inside    : Bool
    property pos_nudge : Point

    def initialize(intersection : Intersection, ray : Ray)
      @distance  = intersection.distance
      @solid     = intersection.solid
      @position  = Point.from(ray.position(@distance))
      @eye_v     = Vector.from(-ray.direction)
      @normal_v  = Vector.from(@solid.normal_at(@position))
      @pos_nudge = Point.from(@position + (@normal_v * EPSILON))

      if @normal_v.dot(@eye_v) < 0
        @inside = true
        @normal_v = Vector.from(-@normal_v)
      else
        @inside = false
      end
    end
  end
end
