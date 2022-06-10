require "./StbImage"

module Tracer
  class Canvas
    getter width  : UInt32
    getter height : UInt32
    @pixels : Array(UInt32)

    def initialize(@width : UInt32, @height : UInt32, color : UInt32 = 0)
      @pixels = Array.new(@width * @height) { color }
    end

    def initialize(@width : UInt32, @height : UInt32, @pixels : Array(UInt32))
    end

    def self.load(filename : String) : Canvas|Nil
      width    : LibC::Int = 0
      height   : LibC::Int = 0
      channels : LibC::Int = 3
      pixels = StbImage.readPNG filename, pointerof(width), pointerof(height), pointerof(channels), 0

      return nil if pixels.nil?

      # there MUST be a better way to just cast a C pointer to a Crystal array... right??
      pixel_curr = pixels
      pixel_arr = [] of UInt32
      pixel_arr_count = width * height
      (0...pixel_arr_count).each do |index|
        pixel_arr.push pixel_curr.value
        pixel_curr += 1
      end
      StbImage.freePNG pixels
      Canvas.new width.to_u32, height.to_u32, pixel_arr
    end

    def set(x : UInt32, y : UInt32, color : UInt32) : Void
      @pixels[(y * @width) + x] = color
    end

    def get(x : UInt32, y : UInt32) : UInt32
      @pixels[(y * @width) + x]
    end

    def write(filename : String, flipped : Bool = false) : Bool
      StbImage.flipVertically(flipped ? 1 : 0)
      result = StbImage.writePNG(filename, @width, @height, 4, @pixels, @width * 4)
      result != 0
    end
  end
end
