require "./Material"
require "./Matrices"

module Tracer
  class Solid
    @transform                   : M4x4
    @transform_inverse           : M4x4
    @transform_inverse_transpose : M4x4
    property material : Material   = Material.new
    property texture  : Canvas|Nil = nil

    def initialize()
      @transform                   = M4x4.identity
      @transform_inverse           = @transform.inverse
      @transform_inverse_transpose = @transform_inverse.transpose
    end
    def initialize(@transform : M4x4)
      @transform_inverse           = @transform.inverse
      @transform_inverse_transpose = @transform_inverse.transpose
      @material                    = Material.new
    end
    def initialize(@material : Material)
      @transform                   = M4x4.identity
      @transform_inverse           = @transform.inverse
      @transform_inverse_transpose = @transform_inverse.transpose
    end
    def initialize(@transform : M4x4, @material : Material)
      @transform_inverse           = @transform.inverse
      @transform_inverse_transpose = @transform_inverse.transpose
    end

    def transform : M4x4
      @transform
    end
    def transform=(matrix : M4x4)
      @transform                   = matrix
      @transform_inverse           = @transform.inverse
      @transform_inverse_transpose = @transform_inverse.transpose
    end

    def transform_inverse : M4x4
      @transform_inverse
    end

    def transform_inverse_transpose : M4x4
      @transform_inverse_transpose
    end

    def normal_at(world_point : V4) : V4
      return V4.new 0.0, 0.0, 0.0, 0.0
    end

    def intersections(ray : Ray) : Array(Intersection)
      return [] of Intersection
    end
  end
end
