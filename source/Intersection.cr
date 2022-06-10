require "./Solid"
require "./Solid"
require "./V4"
require "./Ray"

module Tracer
  class Intersection
    property distance : Float64
    property solid    : Solid
    property color    : Color|Nil

    def initialize(@distance : Float64, @solid : Solid, @color : Color|Nil = nil)
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
    property color     : Color|Nil
    property position  : Point
    property eye_v     : Vector
    property normal_v  : Vector
    property reflect_v : Vector
    property inside    : Bool
    property pos_nudge : Point

    def initialize(intersection : Intersection, ray : Ray)
      @distance  = intersection.distance
      @solid     = intersection.solid
      @color     = intersection.color
      @position  = Point.from(ray.position(@distance))
      @eye_v     = Vector.from((-ray.direction).normalize)
      @normal_v  = Vector.from(@solid.normal_at(@position))
      @reflect_v = Vector.from(Vector.from(ray.direction).reflect(@normal_v))

      # Basing nudge on normal_v, as suggested in-book,
      # results in Planes requiring a specific orientation, otherwise they'll always be in-shadow.
      # Using eye_direction (instead of normal_direction), seems to solve this fine.
      @pos_nudge = Point.from(@position + (@eye_v * EPSILON))

      if @normal_v.dot(@eye_v) < 0
        @inside = true
        @normal_v = Vector.from(-@normal_v)
      else
        @inside = false
      end
    end
  end
end
