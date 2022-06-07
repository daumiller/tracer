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
  end
end
