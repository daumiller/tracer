# crystal run source/main.cr --link-flags $(pwd)/stb_image_write.a
# crystal spec tests -v --error-trace --link-flags $(pwd)/stb_image_write.a

module Tracer
  VERSION = "0.1.0"
  EPSILON = 0.00001
  EPSILON_COLORS = 0.01

  def self.feq(a : Float64, b : Float64, error : Float64 = EPSILON) : Bool
    (a - b).abs < error
  end
end

require "./Solid"
require "./Sphere"
require "./Intersection"
require "./V4"
require "./Matrices"
require "./Ray"
require "./Canvas"

# canvas    = Tracer::Canvas.new 128, 128, 0xFF444444
# penclr    = Tracer::Color.new(1.0, 0.0, 1.0).to_u32
# dot_world = Tracer::Point.new(0.0, 0.8, 0.0)
# rothour   = Tracer::M4x4.rotation_z(Math::TAU / 12.0)

# cnv_scale = Tracer::M4x4.scale canvas.width.to_f64/2.0, canvas.height.to_f64/2.0, 1.0
# cnv_xlate = Tracer::M4x4.translation canvas.width.to_f64/2.0, canvas.height.to_f64/2.0, 0.0
# cnv_prep  = cnv_xlate * cnv_scale

# (0..11).each do |index|
#   dot_world  = rothour * dot_world

#   dot_canvas = cnv_prep * dot_world
#   dot_canvas_x = dot_canvas.x.round.to_i32
#   dot_canvas_y = dot_canvas.y.round.to_i32
#   canvas.set dot_canvas_x.to_u32, dot_canvas_y.to_u32, penclr
# end
# canvas.write "clock.png"
