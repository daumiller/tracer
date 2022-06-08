# crystal spec tests/Camera_spec.cr -v --error-trace
require "spec"
require "../source/Tracer"
include Tracer

describe Camera do
  describe "Initializers" do
    it "does basic initialization" do
      c = Camera.new 160_u32, 120_u32, Math::TAU/4.0
      c.width.should  eq(160_u32)
      c.height.should eq(120_u32)
      c.fov.should be_close(Math::TAU/4.0, EPSILON)
      (c.transform == M4x4.identity).should be_true
    end
  end

  describe "Pixel Size" do
    it "calculates the correct pixel size" do
      c = Camera.new 200_u32, 125_u32, Math::TAU/4.0
      c.pixel_size.should be_close(0.01, EPSILON)

      c = Camera.new 125_u32, 200_u32, Math::TAU/4.0
      c.pixel_size.should be_close(0.01, EPSILON)
    end
  end

  describe "Rays for Pixels" do
    it "returns a ray through the center of the canvas" do
      c = Camera.new 201_u32, 101_u32, Math::TAU/4.0
      r = c.ray_for_pixel 100_u32, 50_u32
      (r.origin == Point.new(0.0, 0.0, 0.0)).should be_true
      (r.direction == Vector.new(0.0, 0.0, -1.0)).should be_true
    end

    it "returns a ray through the corner of the canvas" do
      c = Camera.new 201_u32, 101_u32, Math::TAU/4.0
      r = c.ray_for_pixel 0_u32, 0_u32
      (r.origin == Point.new(0.0, 0.0, 0.0)).should be_true
      (r.direction == Vector.new(0.66519, 0.33259, -0.66851)).should be_true
    end

    it "returns a ray when the camera is transformed" do
      t = M4x4.rotation_y(Math::TAU/8.0) * M4x4.translation(0.0, -2.0, 5.0)
      c = Camera.new 201_u32, 101_u32, Math::TAU/4.0, t
      r = c.ray_for_pixel 100_u32, 50_u32
      sqrt_2 = Math.sqrt(2.0)
      (r.origin == Point.new(0.0, 2.0, -5.0)).should be_true
      (r.direction == Vector.new(sqrt_2/2.0, 0.0, -sqrt_2/2.0)).should be_true
    end
  end
end
