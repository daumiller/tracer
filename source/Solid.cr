require "./Matrices"

module Tracer
  class Solid
    @transform                   : M4x4
    @transform_inverse           : M4x4
    @transform_inverse_transpose : M4x4

    def initialize()
      @transform                   = M4x4.identity
      @transform_inverse           = @transform.inverse
      @transform_inverse_transpose = @transform_inverse.transpose
    end
    def initialize(@transform : M4x4)
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
  end
end
