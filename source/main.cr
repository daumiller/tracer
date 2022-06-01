# crystal run source/main.cr --link-flags $(pwd)/stb_image_write.a

module Tracer
  VERSION = "0.1.0"
  EPSILON = 0.00001
  EPSILON_COLORS = 0.01

  def self.feq(a : Float64, b : Float64, error : Float64 = EPSILON) : Bool
    (a - b).abs < error
  end
end

require "./V4"
require "./Canvas"

# Tracer::Canvas.new(128, 128, 0xFF0000FF).write("red.png")
# Tracer::Canvas.new(128, 128, 0xFF00FF00).write("green.png")
# Tracer::Canvas.new(128, 128, 0xFFFF0000).write("blue.png")
# Tracer::Canvas.new(128, 128, 0xFF00FFFF).write("yellow.png")
# Tracer::Canvas.new(128, 128, 0xFFFFFF00).write("cyan.png")
# Tracer::Canvas.new(128, 128, 0xFFFF00FF).write("magenta.png")

# off_white = Tracer::Color.new(1.0, 0.9, 0.9)
# violet = Tracer::Color.new(1.0, 0.0, 1.0)
# greenish = Tracer::Color.new(0.0, 0.8, 0.0)
# canvas = Tracer::Canvas.new(320, 240, off_white.to_u32)
# (0..319).each do |index|
#   canvas.set index.to_u32, 120_u32, violet.to_u32
#   canvas.set index.to_u32, 121_u32, violet.to_u32
#   canvas.set index.to_u32, 122_u32, violet.to_u32
#   canvas.set index.to_u32, 123_u32, violet.to_u32
#   canvas.set index.to_u32, 124_u32, violet.to_u32
#   canvas.set index.to_u32, 125_u32, violet.to_u32
# end
# (0..239).each do |index|
#   canvas.set 160_u32, index.to_u32, greenish.to_u32
# end
# canvas.write("test.png")
