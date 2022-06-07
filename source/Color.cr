module Tracer
  class Color
    property r : Float64
    property g : Float64
    property b : Float64

    # ABGR -> #AABBGGRR
    def initialize(@r : Float64, @g : Float64, @b : Float64)
    end

    def initialize(color : UInt32)
      @b = ((color >> 16) & 0xFF) / 255.0
      @g = ((color >>  8) & 0xFF) / 255.0
      @r = ((color >>  0) & 0xFF) / 255.0
    end

    def to_u32
      r_clipped = (@r > 1.0) ? 1.0 : @r
      g_clipped = (@g > 1.0) ? 1.0 : @g
      b_clipped = (@b > 1.0) ? 1.0 : @b

      ua : UInt32 = 0xFF000000_u32
      ub : UInt32 = ((b_clipped * 255.0).to_u32 & 0xFF) << 16
      ug : UInt32 = ((g_clipped * 255.0).to_u32 & 0xFF) <<  8
      ur : UInt32 = ((r_clipped * 255.0).to_u32 & 0xFF) <<  0
      ua | ub | ug | ur
    end

    def blend(other : Color) : Color
      Color.new @r*other.r, @g*other.g, @b*other.b
    end

    def +(other : Color) : Color
      Color.new @r+other.r, @g+other.g, @b+other.b
    end
    def -(other : Color) : Color
      Color.new @r-other.r, @g-other.g, @b-other.b
    end
    def - : Color
      Color.new -@r, -@g, -@b
    end
    def *(scalar : Float64) : Color
      Color.new @r*scalar, @g*scalar, @b*scalar
    end
    def /(scalar : Float64) : Color
      Color.new @r/scalar, @g/scalar, @b/scalar
    end

    def ==(other : Color) : Bool
      return false unless Tracer.feq(@r, other.r, Tracer::EPSILON_COLORS)
      return false unless Tracer.feq(@g, other.g, Tracer::EPSILON_COLORS)
      return false unless Tracer.feq(@b, other.b, Tracer::EPSILON_COLORS)
      true
    end
  end
end
