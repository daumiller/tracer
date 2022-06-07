# crystal spec tests/V4_spec.cr -v --error-trace
require "spec"
require "../source/Tracer"

describe Tracer::V4 do
  describe "base initializer" do
    it "a v4 with w=1.0 is a point" do
      v4 = Tracer::V4.new 4.3, -4.2, 3.1, 1.0
      v4.isa_vector?.should eq(false)
      v4.isa_point?.should eq(true)
    end

    it "a v4 with w=0.0 is a vector" do
      v4 = Tracer::V4.new 4.3, -4.2, 3.1, 0.0
      v4.isa_vector?.should eq(true)
      v4.isa_point?.should eq(false)
    end
  end

  describe "child class initializers" do
    it "a new Point is initialized correctly" do
      point = Tracer::Point.new 4.0, -4.0, 3.0
      point.x.should be_close( 4.0, Tracer::EPSILON)
      point.y.should be_close(-4.0, Tracer::EPSILON)
      point.z.should be_close( 3.0, Tracer::EPSILON)
      point.w.should be_close( 1.0, Tracer::EPSILON)
    end

    it "a new Vector is initialized correctly" do
      vector = Tracer::Vector.new 4.0, -4.0, 3.0
      vector.x.should be_close( 4.0, Tracer::EPSILON)
      vector.y.should be_close(-4.0, Tracer::EPSILON)
      vector.z.should be_close( 3.0, Tracer::EPSILON)
      vector.w.should be_close( 0.0, Tracer::EPSILON)
    end
  end

  describe "operators" do
    it "negates a V4" do
      vector = -(Tracer::Vector.new(1.0, -2.0, 3.0))
      vector.x.should be_close(-1.0, Tracer::EPSILON)
      vector.y.should be_close( 2.0, Tracer::EPSILON)
      vector.z.should be_close(-3.0, Tracer::EPSILON)
      vector.w.should be_close( 0.0, Tracer::EPSILON)
    end

    it "compares equality" do
      v4a = Tracer::V4.new 1.0, 2.0, 3.0, 0.0
      v4b = Tracer::V4.new 1.5, 2.5, 3.5, 0.5
      (v4a == v4b).should eq(false)
      (v4a == v4a).should eq(true)
      (v4b == v4b).should eq(true)
    end

    it "add V4s" do
      v4a = Tracer::V4.new 1.0, 2.0, 3.0,  4.0
      v4b = Tracer::V4.new 2.0, 4.0, 8.0, 16.0
      v4c = v4a + v4b
      (v4a == v4c).should eq(false)
      v4c.x.should be_close( 3.0, Tracer::EPSILON)
      v4c.y.should be_close( 6.0, Tracer::EPSILON)
      v4c.z.should be_close(11.0, Tracer::EPSILON)
      v4c.w.should be_close(20.0, Tracer::EPSILON)
      v4a += v4b
      (v4a == v4c).should eq(true)
    end

    it "subtracts V4s" do
      v4a = Tracer::V4.new 11.0, 7.0, 23.0, -5.0
      v4b = Tracer::V4.new  2.0, 4.0,  8.0, 16.0
      v4c = v4a - v4b
      (v4a == v4c).should eq(false)
      v4c.x.should be_close(  9.0, Tracer::EPSILON)
      v4c.y.should be_close(  3.0, Tracer::EPSILON)
      v4c.z.should be_close( 15.0, Tracer::EPSILON)
      v4c.w.should be_close(-21.0, Tracer::EPSILON)
      v4a -= v4b
      (v4a == v4c).should eq(true)
    end

    it "scalar multiplication" do
      v4a = Tracer::V4.new 33.0, -5.0, -11.0, 0.0
      v4b = v4a * 3.0
      (v4b == v4a).should eq(false)
      (v4b == Tracer::V4.new(99.0, -15.0, -33.0, 0.0)).should eq(true)

      v4c = Tracer::V4.new(-12.0, 68.0, 33.0, 1.0)
      v4d = v4c / 2.0
      (v4d == v4c).should eq(false)
      (v4d == Tracer::V4.new(-6.0, 34.0, 16.5, 0.5)).should eq(true)
    end

    it "dot product" do
      Tracer::Vector.new(1.0,2.0,3.0).dot(Tracer::Vector.new(2.0, 3.0, 4.0)).should be_close(20.0, Tracer::EPSILON)
    end

    it "cross product" do
      v4a = Tracer::Vector.new(1.0, 2.0, 3.0)
      v4b = Tracer::Vector.new(2.0, 3.0, 4.0)
      (v4a.cross(v4b) == Tracer::Vector.new(-1.0,  2.0, -1.0)).should eq(true)
      (v4b.cross(v4a) == Tracer::Vector.new( 1.0, -2.0,  1.0)).should eq(true)
    end

    it "magnitude" do
      Tracer::Vector.new( 1.0,  0.0,  0.0).magnitude.should be_close(          1.0, Tracer::EPSILON)
      Tracer::Vector.new( 0.0,  1.0,  0.0).magnitude.should be_close(          1.0, Tracer::EPSILON)
      Tracer::Vector.new( 0.0,  0.0,  1.0).magnitude.should be_close(          1.0, Tracer::EPSILON)
      Tracer::Vector.new( 1.0,  2.0,  3.0).magnitude.should be_close(Math.sqrt(14), Tracer::EPSILON)
      Tracer::Vector.new(-1.0, -2.0, -3.0).magnitude.should be_close(Math.sqrt(14), Tracer::EPSILON)
    end

    it "normalize" do
      (Tracer::Vector.new( 4.0, 0.0, 0.0).normalize == Tracer::Vector.new(1.0, 0.0, 0.0)).should eq(true)
      v4a = Tracer::Vector.new(1.0, 2.0, 3.0)
      v4b = Tracer::Vector.new(1.0 / Math.sqrt(14), 2.0 / Math.sqrt(14), 3.0 / Math.sqrt(14))
      (v4a == v4b).should eq(false)
      v4a.normalize!
      (v4a == v4b).should eq(true)
      v4a.magnitude.should be_close(1.0, Tracer::EPSILON)

      Tracer::V4.new(11.0, 33.0, -7.34, 2.85).normalize.magnitude.should be_close(1.0, Tracer::EPSILON)
    end

    it "blend" do
      clr1 = Tracer::Color.new 1.0, 0.2, 0.4
      clr2 = Tracer::Color.new 0.0, 0.0, 0.0
      clr2.r = 0.9
      clr2.g = 1.0
      clr2.b = 0.1
      clr3 = clr1.blend(clr2)
      clr3.r.should be_close(0.90, Tracer::EPSILON)
      clr3.g.should be_close(0.20, Tracer::EPSILON)
      clr3.b.should be_close(0.04, Tracer::EPSILON)
    end

    it "reflects" do
      v = Tracer::Vector.new 1.0, -1.0, 0.0
      n = Tracer::Vector.new 0.0, 1.0, 0.0
      r = v.reflect n
      (r == Tracer::Vector.new(1.0, 1.0, 0.0)).should be_true

      v = Tracer::Vector.new 0.0, -1.0, 0.0
      n = Tracer::Vector.new Math.sqrt(2.0)/2.0, Math.sqrt(2.0)/2.0, 0.0
      r = v.reflect n
      (r == Tracer::Vector.new(1.0, 0.0, 0.0)).should be_true
    end
  end
end
