module Tracer
  VERSION = "0.1.0"
  EPSILON = 0.00001
  EPSILON_COLORS = 0.01

  def self.feq(a : Float64, b : Float64, error : Float64 = EPSILON) : Bool
    (a - b).abs < error
  end
end

require "./Color"
require "./Light"
require "./Material"
require "./Solid"
require "./Sphere"
require "./World"
require "./Intersection"
require "./V4"
require "./Matrices"
require "./Ray"
require "./Canvas"
require "./Phong"
require "./Camera"
