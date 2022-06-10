require "./Solid"

module Tracer
  class Sphere < Solid
    def normal_at(world_point : V4) : V4
      object_point   = @transform_inverse * world_point
      object_normal  = object_point - Point.new(0.0, 0.0, 0.0)
      world_normal   = @transform_inverse_transpose * object_normal
      world_normal.w = 0
      world_normal.normalize
    end

    def intersections(ray : Ray) : Array(Intersection)
      hits = [] of Intersection
      tx_ray = ray.transform @transform_inverse

      sphere_to_ray : V4 = tx_ray.origin - Point.new(0.0, 0.0, 0.0)
      a : Float64 = tx_ray.direction.dot(tx_ray.direction)
      b : Float64 = tx_ray.direction.dot(sphere_to_ray) * 2.0
      c : Float64 = sphere_to_ray.dot(sphere_to_ray) - 1.0
      d : Float64 = (b*b) - (4.0 * a * c)
      return hits if d < 0.0

      sq_d = Math.sqrt(d)
      dist_a : Float64 = (-b - sq_d) / (2.0 * a)
      dist_b : Float64 = (-b + sq_d) / (2.0 * a)
      if @texture.nil?
        hits.push Intersection.new(dist_a, self)
        hits.push Intersection.new(dist_b, self)
      else
        # find hit point on sphere
        # get normal from this point to do UV mapping to texture, if @texture
        # https://www.mvps.org/directx/articles/spheremap.htm
        texture : Canvas = @texture.not_nil!
        normal_a = Vector.from(sphere_to_ray + (tx_ray.direction * dist_a)).normalize
        normal_b = Vector.from(sphere_to_ray + (tx_ray.direction * dist_b)).normalize
        a_u = (Math.asin(normal_a.x)/Math::PI) + 0.5
        a_v = (Math.asin(normal_a.y)/Math::PI) + 0.5
        b_u = (Math.asin(normal_b.x)/Math::PI) + 0.5
        b_v = (Math.asin(normal_b.y)/Math::PI) + 0.5
        a_ux = (a_u * (texture.width - 1).to_f64).to_u32
        a_vy = ((1.0 - a_v) * (texture.height - 1).to_f64).to_u32
        b_ux = (b_u * (texture.width - 1).to_f64).to_u32
        b_vy = ((1.0 - b_v) * (texture.height - 1).to_f64).to_u32
        a_color = texture.get a_ux, a_vy
        b_color = texture.get b_ux, b_vy
        hits.push Intersection.new(dist_a, self, Color.new(a_color))
        hits.push Intersection.new(dist_b, self, Color.new(b_color))
      end
      
      hits
    end
  end
end
