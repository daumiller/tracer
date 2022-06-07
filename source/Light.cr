require "./Color"
require "./V4"

module Tracer
  class Light
    property color    : Color;
    property position : Point;

    def initialize(@position : Point, @color : Color)
    end

    def initialize(@position : Point)
      @color = Color.new 1.0, 1.0, 1.0
    end
  end
end
