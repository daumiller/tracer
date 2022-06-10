require "./Color"
require "./Canvas"

module Tracer
  class Material
    property color     : Color
    property ambient   : Float64 # 0.0 - 1.0
    property diffuse   : Float64 # 0.0 - 1.0
    property specular  : Float64 # 0.0 - 1.0
    property shininess : Float64 # 10.0 ~ 200.0
    property texture   : Canvas|Nil

    def initialize()
      @color     = Color.new 1.0, 1.0, 1.0
      @ambient   = 0.1
      @diffuse   = 0.9
      @specular  = 0.9
      @shininess = 200.0
      @texture   = nil
    end

    def initialize(@color : Color)
      @ambient   = 0.1
      @diffuse   = 0.9
      @specular  = 0.9
      @shininess = 200.0
      @texture   = nil
    end

    def initialize(@texture : Canvas)
      @color     = Color.new 1.0, 1.0, 1.0
      @ambient   = 0.1
      @diffuse   = 0.9
      @specular  = 0.9
      @shininess = 200.0
    end

    def initialize(@color, @ambient, @diffuse, @specular, @shininess)
      @texture = nil
    end
  end
end
