# crystal spec tests/Sphere_spec.cr -v --error-trace
require "spec"
require "../source/Tracer"
include Tracer

describe Sphere do
  describe "Initializer" do
    it "has default values" do
      s = Sphere.new
      (s.material.color == Color.new(1.0, 1.0, 1.0)).should be_true
      s.material.ambient.should be_close(0.1, EPSILON)
      s.material.diffuse.should be_close(0.9, EPSILON)
      s.material.specular.should be_close(0.9, EPSILON)
      s.material.shininess.should be_close(200.0, EPSILON)
    end
  end

  describe "Normals" do
    it "computes basic normals" do
      s = Sphere.new
      (s.normal_at(Point.new(1.0, 0.0, 0.0)) == Vector.new(1.0, 0.0, 0.0)).should be_true
      (s.normal_at(Point.new(0.0, 1.0, 0.0)) == Vector.new(0.0, 1.0, 0.0)).should be_true
      (s.normal_at(Point.new(0.0, 0.0, 1.0)) == Vector.new(0.0, 0.0, 1.0)).should be_true
      (s.normal_at(Point.new(0.5773502692, 0.5773502692, 0.5773502692)) == Vector.new(0.5773502692, 0.5773502692, 0.5773502692)).should be_true
    end

    it "computes transformed normals" do
      s = Sphere.new M4x4.translation(0.0, 1.0, 0.0)
      (s.normal_at(Point.new(0.0, 1.70711, -0.70711)) == Vector.new(0.0, 0.70711, -0.70711)).should be_true

      s.transform = M4x4.scale(1.0, 0.5, 1.0) * M4x4.rotation_z(Math::TAU / 2.5)
      (s.normal_at(Point.new(0.0, 0.7071067812, -0.7071067812)) == Vector.new(0.0, 0.97014, -0.24254)).should be_true
    end
  end
end
