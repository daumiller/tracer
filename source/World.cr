require "./Color"
require "./Light"
require "./Solid"
require "./Ray"
require "./Intersection"
require "./Phong"

module Tracer
  class World
    property lights : Array(Light) = [] of Light
    property solids : Array(Solid) = [] of Solid

    def initialize
    end

    def initialize(@lights : Array(Light))
    end

    def initialize(@solids : Array(Solids))
    end

    def initialize(@lights : Array(Light), @solids : Array(Solid))
    end

    def intersections(ray : Ray) : Array(Intersection)
      total_intersections = [] of Intersection
      @solids.each do |solid|
        total_intersections += ray.intersections solid
      end

      total_intersections.sort { |a, b| a.distance <=> b.distance }
    end

    def phong_ray_intersection(ri : RayIntersection) : Color
      color = Color.new 0.0, 0.0, 0.0
      @lights.each do |light|
        color += Tracer.phong ri.solid.material, light, ri.position, ri.eye_v, ri.normal_v
      end
      color
    end

    def color_at(ray : Ray) : Color
      intersections = self.intersections ray
      return Color.new(0.0, 0.0, 0.0) if intersections.size == 0

      intersections.each do |inter|
        next if inter.distance < 0.0
        return self.phong_ray_intersection RayIntersection.new(inter, ray)
      end

      # all values were negative
      return Color.new(0.0, 0.0, 0.0)
    end
  end
end
