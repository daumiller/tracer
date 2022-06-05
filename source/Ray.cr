require "./V4"
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

    def intersections(sphere : Sphere) : Array(Intersection)
      hits = [] of Intersection

      sphere_to_ray : V4 = @origin - Point.new(0.0, 0.0, 0.0)
      a : Float64 = @direction.dot(@direction)
      b : Float64 = @direction.dot(sphere_to_ray) * 2.0
      c : Float64 = sphere_to_ray.dot(sphere_to_ray) - 1.0
      d : Float64 = (b*b) - (4.0 * a * c)
      return hits if d < 0.0

      sq_d = Math.sqrt(d)
      hits.push Intersection.new((-b - sq_d) / (2.0 * a), sphere)
      hits.push Intersection.new((-b + sq_d) / (2.0 * a), sphere)
      return hits
    end
  end
end
