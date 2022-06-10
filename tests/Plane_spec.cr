# crystal spec tests/Plane_spec.cr -v --error-trace
require "spec"
require "../source/Tracer"
include Tracer

describe Plane do
  describe "Normals" do
    it "has a constant normal" do
      p = Plane.new
      n = Vector.new 0.0, 1.0, 0.0
      (p.normal_at(Point.new( 0.0, 0.0,   0.0)) == n).should be_true
      (p.normal_at(Point.new(10.0, 0.0, -10.0)) == n).should be_true
      (p.normal_at(Point.new(-5.0, 0.0, 150.0)) == n).should be_true
    end
  end

  describe "Intersections" do
    it "doesn't intersect with a parallel ray" do
      p = Plane.new
      r = Ray.new Point.new(0.0, 10.0, 0.0), Vector.new(0.0, 0.0, 1.0)
      p.intersections(r).size.should eq(0)
    end

    it "doesn't intersect with a coplanar ray" do
      p = Plane.new
      r = Ray.new Point.new(0.0, 0.0, 0.0), Vector.new(0.0, 0.0, 1.0)
      p.intersections(r).size.should eq(0)
    end

    it "intersects with a ray from above" do
      p = Plane.new
      r = Ray.new Point.new(0.0, 1.0, 0.0), Vector.new(0.0, -1.0, 0.0)
      i = p.intersections r
      i.size.should eq(1)
      i[0].distance.should be_close(1.0, EPSILON)
      i[0].solid.should be(p)
    end

    it "intersescts with a ray from below" do
      p = Plane.new
      r = Ray.new Point.new(0.0, -1.0, 0.0), Vector.new(0.0, 1.0, 0.0)
      i = p.intersections r
      i.size.should eq(1)
      i[0].distance.should be_close(1.0, EPSILON)
      i[0].solid.should be(p)
    end
  end
end
