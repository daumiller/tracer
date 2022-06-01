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
require "./Matrices"
require "./Canvas"
