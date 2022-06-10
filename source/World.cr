require "./Color"
require "./Light"
require "./Solid"
require "./Ray"
require "./Intersection"
require "./Phong"

module Tracer
  MAX_REFLECTION_COUNT = 10_u32

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
        total_intersections += solid.intersections ray
      end

      total_intersections.sort { |a, b| a.distance <=> b.distance }
    end

    def phong_ray_intersection(ri : RayIntersection, depth : UInt32) : Color
      color = Color.new 0.0, 0.0, 0.0
      @lights.each do |light|
        in_shadow = self.in_shadow ri.pos_nudge, light
        color += Tracer.phong ri.solid.material, ri.color, light, ri.position, ri.eye_v, ri.normal_v, in_shadow
      end

      return color if (ri.solid.material.reflectivity < EPSILON)
      color += self.color_at(Ray.new(ri.pos_nudge, ri.reflect_v), depth+1) * ri.solid.material.reflectivity

      color
    end

    def in_shadow(position : Point, light : Light) : Bool
      v = (light.position - position)
      distance = v.magnitude
      direction = Vector.from(v.normalize)
      intersections = self.intersections Ray.new(position, direction)

      intersections.each do |inter|
        next if inter.distance < 0.0
        break if inter.distance > distance
        return true if inter.distance < distance
      end

      false
    end

    def color_at(ray : Ray, depth : UInt32 = 0) : Color
      return Color.new(0.0, 0.0, 0.0) if (depth == MAX_REFLECTION_COUNT)

      intersections = self.intersections ray
      return Color.new(0.0, 0.0, 0.0) if intersections.size == 0

      intersections.each do |inter|
        next if inter.distance < 0.0
        return self.phong_ray_intersection RayIntersection.new(inter, ray), depth
      end

      # all values were negative
      return Color.new(0.0, 0.0, 0.0)
    end
  end
end
