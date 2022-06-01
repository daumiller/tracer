require "./StbImagewrite"

module Tracer
  class Canvas
    getter width  : UInt32
    getter height : UInt32
    @pixels : Array(UInt32)

    def initialize(@width : UInt32, @height : UInt32, color : UInt32 = 0)
      @pixels = Array.new(@width * @height) { color }
    end

    def set(x : UInt32, y : UInt32, color : UInt32) : Void
      @pixels[(y * @width) + x] = color
    end

    def get(x : UInt32, y : UInt32) : UInt32
      @pixels[(y * @width) + x]
    end

    def write(filename : String, flipped : Bool = false) : Bool
      StbImageWrite.flipVertically(flipped ? 1 : 0)
      result = StbImageWrite.writePNG(filename, @width, @height, 4, @pixels, @width * 4)
      result != 0
    end
  end
end
