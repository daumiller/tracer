# crystal spec tests/Ray_spec.cr -v --error-trace
require "spec"
require "../source/Tracer"
include Tracer

describe Ray do
  describe "Positions" do
    it "calculates positions correctly" do
      ray = Ray.new(Point.new(2.0, 3.0, 4.0), Vector.new(1.0, 0.0, 0.0))
      (ray.position( 0.0) == Point.new(2.0, 3.0, 4.0)).should be_true
      (ray.position( 1.0) == Point.new(3.0, 3.0, 4.0)).should be_true
      (ray.position(-1.0) == Point.new(1.0, 3.0, 4.0)).should be_true
      (ray.position( 2.5) == Point.new(4.5, 3.0, 4.0)).should be_true
    end
  end

  describe "Intersections" do
    it "intersects spheres" do
      # through center (2 intersections)
      ray = Ray.new(Point.new(0.0, 0.0, -5.0), Vector.new(0.0, 0.0, 1.0))
      sphere = Sphere.new
      xs = sphere.intersections ray
      xs.size.should eq(2)
      xs[0].distance.should be_close(4.0, EPSILON)
      xs[1].distance.should be_close(6.0, EPSILON)
      xs[0].solid.should be(sphere)
      xs[1].solid.should be(sphere)

      # through top point (single intersection, reported twice)
      ray = Ray.new(Point.new(0.0, 1.0, -5.0), Vector.new(0.0, 0.0, 1.0))
      xs = sphere.intersections ray
      xs.size.should eq(2)
      xs[0].distance.should be_close(5.0, EPSILON)
      xs[1].distance.should be_close(5.0, EPSILON)

      # missed sphere (0 intersections)
      ray = Ray.new(Point.new(0.0, 2.0, -5.0), Vector.new(0.0, 0.0, 1.0))
      xs = sphere.intersections ray
      xs.size.should eq(0)

      # inside sphere (1 intersection behind, 1 intersection in front)
      ray = Ray.new(Point.new(0.0, 0.0, 0.0), Vector.new(0.0, 0.0, 1.0))
      xs = sphere.intersections ray
      xs.size.should eq(2)
      xs[0].distance.should be_close(-1.0, EPSILON)
      xs[1].distance.should be_close( 1.0, EPSILON)

      # beyond sphere (2 intersections behind)
      ray = Ray.new(Point.new(0.0, 0.0, 5.0), Vector.new(0.0, 0.0, 1.0))
      xs = sphere.intersections ray
      xs.size.should eq(2)
      xs[0].distance.should be_close(-6.0, EPSILON)
      xs[1].distance.should be_close(-4.0, EPSILON)
    end

    it "intersects spheres with transforms" do
      ray = Ray.new(Point.new(0.0, 0.0, -5.0), Vector.new(0.0, 0.0, 1.0))
      sphere = Sphere.new M4x4.scale(2.0, 2.0, 2.0)
      xs = sphere.intersections ray
      xs.size.should eq(2)
      xs[0].distance.should be_close(3.0, EPSILON)
      xs[1].distance.should be_close(7.0, EPSILON)
      xs[0].solid.should be(sphere)
      xs[1].solid.should be(sphere)
  
      sphere.transform = M4x4.translation 5.0, 0.0, 0.0
      xs = sphere.intersections ray
      xs.size.should eq(0)
    end

    # not actually part of Ray; but, whatevs...
    it "chooses hit from intersections" do
      sphere = Sphere.new
      inters : Array(Intersection) = [ Intersection.new(1.0, sphere), Intersection.new(2.0, sphere) ]
      Intersection.hit(inters).should be(inters[0])
  
      inters = [ Intersection.new(-1.0, sphere), Intersection.new(2.0, sphere) ]
      Intersection.hit(inters).should be(inters[1])
  
      inters = [ Intersection.new(-2.0, sphere), Intersection.new(-1.0, sphere) ]
      Intersection.hit(inters).should be_nil

      inters = [
        Intersection.new( 5.0, sphere),
        Intersection.new( 7.0, sphere),
        Intersection.new(-3.0, sphere),
        Intersection.new( 2.0, sphere),
        Intersection.new( 4.3, sphere),
      ]
      Intersection.hit(inters).should be(inters[3])
    end

    it "precomputes intersections" do
      r = Ray.new Point.new(0.0, 0.0, -5.0), Vector.new(0.0, 0.0, 1.0)
      i = Intersection.new 4.0, Sphere.new
      ri = RayIntersection.new i, r
      ri.distance.should be_close(i.distance, EPSILON)
      ri.solid.should be(i.solid)
      (ri.position == Point.new(0.0, 0.0, -1.0)).should be_true
      (ri.eye_v == Vector.new(0.0, 0.0, -1.0)).should be_true
      (ri.normal_v == Vector.new(0.0, 0.0, -1.0)).should be_true
      ri.inside.should be_false

      r = Ray.new Point.new(0.0, 0.0, 0.0), Vector.new(0.0, 0.0, 1.0)
      i = Intersection.new 1.0, Sphere.new
      ri = RayIntersection.new i, r
      (ri.position == Point.new(0.0, 0.0, 1.0)).should be_true
      (ri.eye_v == Vector.new(0.0, 0.0, -1.0)).should be_true
      (ri.normal_v == Vector.new(0.0, 0.0, -1.0)).should be_true
      ri.inside.should be_true
    end

    it "computes reflection vectors" do
      s = Plane.new
      sq2 = Math.sqrt(2.0)
      r = Ray.new Point.new(0.0, 1.0, -1.0), Vector.new(0.0, -sq2/2.0, sq2/2.0)
      i = Intersection.new sq2, s
      ri = RayIntersection.new i, r
      (ri.reflect_v == Vector.new(0.0, sq2/2.0, sq2/2.0)).should be_true
    end
  end

  describe "Transformations" do
    it "can be transformed" do
      r = Ray.new Point.new(1.0, 2.0, 3.0), Vector.new(0.0, 1.0, 0.0)
      m = M4x4.translation 3.0, 4.0, 5.0
      r2 = r.transform m
      (r2.origin    == Point.new( 4.0, 6.0, 8.0)).should be_true
      (r2.direction == Vector.new(0.0, 1.0, 0.0)).should be_true

      r2 = r.transform M4x4.scale(2.0, 3.0, 4.0)
      (r2.origin    == Point.new( 2.0, 6.0, 12.0)).should be_true
      (r2.direction == Vector.new(0.0, 3.0,  0.0)).should be_true
    end
  end
end
