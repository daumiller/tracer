# crystal spec tests/World_spec.cr -v --error-trace
require "spec"
require "../source/Tracer"
include Tracer

def testing_world : World
  lights : Array(Light) = [
    Light.new(Point.new(-10.0, 10.0, -10.0))
  ]
  solids : Array(Solid) = [
    # WHYYYYYYY?!?!?!? No. Bad Crystal.
    Sphere.new(Material.new(Color.new(0.8, 1.0, 0.6), 0.1, 0.7, 0.2, 200.0)).as(Solid),
    Sphere.new(M4x4.scale(0.5)).as(Solid)
  ]
  World.new lights, solids
end

describe World do
  describe "Initializers" do
    it "initializes a default world" do
      w = World.new
      w.lights.size.should eq(0)
      w.solids.size.should eq(0)
    end

    it "initializes a world with objects (testing world)" do
      w = testing_world

      w.lights.size.should eq(1)
      w.lights[0].position.x.should be_close(-10.0, EPSILON)
      w.lights[0].position.y.should be_close( 10.0, EPSILON)
      w.lights[0].position.z.should be_close(-10.0, EPSILON)

      w.solids.size.should eq(2)
      (w.solids[0].material.color == Color.new(0.8, 1.0, 0.6)).should be_true
      (w.solids[1].transform == M4x4.scale(0.5)).should be_true
    end
  end

  describe "Intersections" do
    it "provides ray intersections" do
      w = testing_world
      r = Ray.new(Point.new(0.0, 0.0, -5.0), Vector.new(0.0, 0.0, 1.0))
      x = w.intersections r

      x.size.should eq(4)
      x[0].distance.should be_close(4.0, EPSILON)
      x[1].distance.should be_close(4.5, EPSILON)
      x[2].distance.should be_close(5.5, EPSILON)
      x[3].distance.should be_close(6.0, EPSILON)
    end

    it "shades ray intersections" do
      w = testing_world
      r = Ray.new Point.new(0.0, 0.0, -5.0), Vector.new(0.0, 0.0, 1.0)
      s = testing_world.solids[0]
      i = Intersection.new 4.0, s
      ri = RayIntersection.new i, r
      c = w.phong_ray_intersection ri
      (c == Color.new(0.38066, 0.47583, 0.2855)).should be_true

      w = testing_world
      w.lights[0] = Light.new Point.new(0.0, 0.25, 0.0)
      r = Ray.new Point.new(0.0, 0.0, 0.0), Vector.new(0.0, 0.0, 1.0)
      s = w.solids[1]
      i = Intersection.new 0.5, s
      ri = RayIntersection.new i, r
      c = w.phong_ray_intersection ri
      # (c == Color.new(0.90498, 0.90498, 0.90498)).should be_true # <- value before adding shadows
      (c == (s.material.color * s.material.ambient)).should be_true # <- value after adding shadows
    end
  end

  describe "World Ray Tracing" do
    it "returns colors for rays in the world" do
      w = testing_world
      r = Ray.new Point.new(0.0, 0.0, -5.0), Vector.new(0.0, 1.0, 0.0)
      c = w.color_at r
      (c == Color.new(0.0, 0.0, 0.0)).should be_true

      r = Ray.new Point.new(0.0, 0.0, -5.0), Vector.new(0.0, 0.0, 1.0)
      c = w.color_at r
      (c == Color.new(0.38066, 0.47583, 0.2855)).should be_true

      w.solids[0].material.ambient = 1.0
      w.solids[1].material.ambient = 1.0
      r = Ray.new Point.new(0.0, 0.0, 0.75), Vector.new(0.0, 0.0, -1.0)
      c = w.color_at r
      (c == w.solids[1].material.color).should be_true
    end
  end

  describe "Points in Shadow" do
    it "returns no shadow when nothing in path" do
      w = testing_world
      p = Point.new 0.0, 10.0, 0.0
      w.in_shadow(p, w.lights[0]).should be_false
    end

    it "returns shadow when object between point and light" do
      w = testing_world
      p = Point.new 10.0, -10.0, 10.0
      w.in_shadow(p, w.lights[0]).should be_true
    end

    it "returns no shadow when point \"behind\" light" do
      w = testing_world
      p = Point.new -20.0, 20.0, -20.0
      w.in_shadow(p, w.lights[0]).should be_false
    end

    it "passes another shadow test" do
      w = testing_world
      p = Point.new -2.0, 2.0, -2.0
      w.in_shadow(p, w.lights[0]).should be_false
    end
  end
end
