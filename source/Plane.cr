require "./Solid"

module Tracer
  class Plane < Solid
    property texture_scale : Float64 = 1.0

    def normal_at(world_point : V4) : V4
      world_normal   = @transform_inverse_transpose * Point.new(0.0, 1.0, 0.0)
      world_normal.w = 0
      world_normal.normalize
    end

    def intersections(ray : Ray) : Array(Intersection)
      tx_ray = ray.transform @transform_inverse
      return [] of Intersection if tx_ray.direction.y.abs < EPSILON

      distance = -tx_ray.origin.y / tx_ray.direction.y
      if @texture.nil?
        return [ Intersection.new(distance, self) ]
      else
        texture : Canvas = @texture.not_nil!
        point = Point.from(tx_ray.origin + (tx_ray.direction * distance))
        scale_width  = texture.width  * @texture_scale
        scale_height = texture.height * @texture_scale
        point_u = (point.x % scale_width ) / scale_width
        point_v = (point.z % scale_height) / scale_height
        point_ux = (       point_u  * (texture.width  - 1).to_f64).to_u32
        point_vy = ((1.0 - point_v) * (texture.height - 1).to_f64).to_u32
        point_color = texture.get point_ux, point_vy
        return [ Intersection.new(distance, self, Color.new(point_color)) ]
      end
    end
  end
end
