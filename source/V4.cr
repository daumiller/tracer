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

    def self.from(v4 : V4) : Point
      point = Point.new v4.x, v4.y, v4.z
      point.w = v4.w
      point
    end
  end

  class Vector < V4
    def initialize(@x : Float64, @y : Float64, @z : Float64)
      @w = 0.0
    end

    def reflect(reflect_around : Vector) : Vector
      v4 = self - (reflect_around * 2.0 * self.dot(reflect_around))
      Vector.new v4.x, v4.y, v4.z
    end

    def self.from(v4 : V4) : Vector
      vector = Vector.new v4.x, v4.y, v4.z
      vector.w = v4.w
      vector
    end
  end
end
