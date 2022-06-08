require "./Matrices"
require "./Ray"

module Tracer
  class Camera
    getter width       : UInt32
    getter height      : UInt32
    getter fov         : Float64
    getter transform   : M4x4
    getter pixel_size  : Float64
    @transform_inverse : M4x4
    @half_width        : Float64
    @half_height       : Float64

    def self.pixel_sizes(width : UInt32, height : UInt32, fov : Float64) : Tuple(Float64, Float64, Float64)
      pixel_size  : Float64 = 0.0
      half_width  : Float64 = 0.0
      half_height : Float64 = 0.0

      half_view   : Float64 = Math.tan(fov / 2.0)
      aspect      : Float64 = width.to_f64 / height.to_f64

      if aspect >= 1.0
        half_width  = half_view
        half_height = half_view / aspect
      else
        half_height = half_view
        half_width  = half_view * aspect
      end

      pixel_size = (half_width * 2.0) / width.to_f64
      { pixel_size, half_width, half_height }
    end

    def initialize(@width, @height)
      @fov       = Math::TAU / 4.0
      @transform = M4x4.identity
      @transform_inverse = @transform.inverse
      pixel_sizes = Camera.pixel_sizes(@width, @height, @fov)
      @pixel_size  = pixel_sizes[0]
      @half_width  = pixel_sizes[1]
      @half_height = pixel_sizes[2]
    end

    def initialize(@width, @height, @fov)
      @transform = M4x4.identity
      @transform_inverse = @transform.inverse
      pixel_sizes = Camera.pixel_sizes(@width, @height, @fov)
      @pixel_size  = pixel_sizes[0]
      @half_width  = pixel_sizes[1]
      @half_height = pixel_sizes[2]
    end

    def initialize(@width, @height, @fov, @transform)
      @transform_inverse = @transform.inverse
      pixel_sizes = Camera.pixel_sizes(@width, @height, @fov)
      @pixel_size  = pixel_sizes[0]
      @half_width  = pixel_sizes[1]
      @half_height = pixel_sizes[2]
    end

    def ray_for_pixel(x : UInt32, y : UInt32) : Ray
      x_offset = (x.to_f64 + 0.5) * @pixel_size
      y_offset = (y.to_f64 + 0.5) * @pixel_size

      world_x = @half_width  - x_offset
      world_y = @half_height - y_offset

      pixel  = Point.from(@transform_inverse * Point.new(world_x, world_y, -1.0))
      origin = Point.from(@transform_inverse * Point.new(0.0, 0.0, 0.0))
      direction = Vector.from((pixel - origin).normalize)

      Ray.new origin, direction
    end
  end
end
