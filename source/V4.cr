module Tracer
  class V4
    property x : Float64
    property y : Float64
    property z : Float64
    property w : Float64

    def initialize(@x : Float64, @y : Float64, @z : Float64, @w : Float64)
    end

    def isa_vector?() : Bool
      w < 0.5
    end

    def isa_point?() : Bool
      w > 0.5
    end

    def ==(other : V4) : Bool
      return false unless Tracer.feq(@w, other.w)
      return false unless Tracer.feq(@z, other.z)
      return false unless Tracer.feq(@y, other.y)
      return false unless Tracer.feq(@x, other.x)
      true
    end

    def +(other : V4) : V4
      V4.new @x + other.x, @y + other.y, @z + other.z, @w + other.w
    end

    def -(other : V4) : V4
      V4.new @x - other.x, @y - other.y, @z - other.z, @w - other.w
    end

    def - : V4
      V4.new -@x, -@y, -@z, -@w
    end

    def *(scalar : Float64) : V4
      V4.new(@x * scalar, @y * scalar, @z * scalar, @w * scalar)
    end

    def /(scalar : Float64) : V4
      V4.new(@x / scalar, @y / scalar, @z / scalar, @w / scalar)
    end

    def dot(other : V4) : Float64
      # smaller dot -> larger angle between vectors
      # larger dot  -> smaller angle between vectors
      # given two unit vectors, dot of  1.0 -> identical vectors
      # given two unit vectors, dot of -1.0 -> opposite vectors
      # given two unit vectors, dot == cosine(angle_between_vectors)
      (@x * other.x) + (@y * other.y) + (@z * other.z) + (@w * other.w)
    end

    def cross(other : V4) : Vector
      # returns new vector, that is perpendicular to both input vectors
      Vector.new(
        (@y * other.z) - (@z * other.y),
        (@z * other.x) - (@x * other.z),
        (@x * other.y) - (@y * other.x)
      )
    end

    def magnitude() : Float64
      Math.sqrt((@x*@x) + (@y*@y) + (@z*@z) + (@w*@w))
    end

    def normalize() : V4
      mag = self.magnitude
      V4.new @x/mag, @y/mag, @z/mag, @w/mag
    end

    def normalize!() : Void
      mag = self.magnitude
      @x /= mag
      @y /= mag
      @z /= mag
      @w /= mag
    end

    def to_s() : String
      "(#{@x}, #{@y}, #{@z}, #{@w})"
    end
  end

  class Point < V4
    def initialize(@x : Float64, @y : Float64, @z : Float64)
      @w = 1.0
    end
  end

  class Vector < V4
    def initialize(@x : Float64, @y : Float64, @z : Float64)
      @w = 0.0
    end
  end

  class Color < V4
    # ABGR -> #AABBGGRR
    def initialize(r : Float64, g : Float64, b : Float64, a : Float64 = 1.0)
      @x = a
      @y = b
      @z = g
      @w = r
    end

    def initialize(color : UInt32)
      @x = ((color >> 24) & 0xFF) / 255.0
      @y = ((color >> 16) & 0xFF) / 255.0
      @z = ((color >>  8) & 0xFF) / 255.0
      @w = ((color >>  0) & 0xFF) / 255.0
    end

    def r
      @w
    end
    def r=(@w)
    end

    def g
      @z
    end
    def g=(@z)
    end

    def b
      @y
    end
    def b=(@y)
    end

    def a
      @x
    end
    def a=(@x)
    end

    def to_u32
      ua : UInt32 = ((@x * 255.0).to_u32 & 0xFF) << 24
      ub : UInt32 = ((@y * 255.0).to_u32 & 0xFF) << 16
      ug : UInt32 = ((@z * 255.0).to_u32 & 0xFF) <<  8
      ur : UInt32 = ((@w * 255.0).to_u32 & 0xFF) <<  0
      ua | ub | ug | ur
    end

    def blend(other : Color) : Color
      Color.new self.r*other.r, self.g*other.g, self.b*other.b, self.a*other.a
    end

    def ==(other : Color) : Bool
      return false unless Tracer.feq(self.r, other.r, Tracer::EPSILON_COLORS)
      return false unless Tracer.feq(self.g, other.g, Tracer::EPSILON_COLORS)
      return false unless Tracer.feq(self.b, other.b, Tracer::EPSILON_COLORS)
      return false unless Tracer.feq(self.a, other.a, Tracer::EPSILON_COLORS)
      true
    end
  end
end
