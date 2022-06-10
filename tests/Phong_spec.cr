# crystal spec tests/Phong_spec.cr -v --error-trace
require "spec"
require "../source/Tracer"
include Tracer

describe "Phong" do
  describe "Lighting Model" do
    it "shades w/ eye & light @ 0 deg" do
      material = Material.new
      position = Point.new 0.0, 0.0, 0.0
      eye_v    = Vector.new 0.0, 0.0, -1.0
      normal_v = Vector.new 0.0, 0.0, -1.0
      light    = Light.new Point.new(0.0, 0.0, -10.0), Color.new(1.0, 1.0, 1.0)
      result   = Tracer.phong material, nil, light, position, eye_v, normal_v
      (result == Color.new(1.9, 1.9, 1.9)).should be_true
    end

    it "shades w/ eye @ 45 deg, light @ 0 deg" do
      sq2ov2 : Float64 = Math.sqrt(2.0) / 2.0
      material = Material.new
      position = Point.new 0.0, 0.0, 0.0
      eye_v    = Vector.new 0.0, sq2ov2, -sq2ov2
      normal_v = Vector.new 0.0, 0.0, -1.0
      light    = Light.new Point.new(0.0, 0.0, -10.0), Color.new(1.0, 1.0, 1.0)
      result   = Tracer.phong material, nil, light, position, eye_v, normal_v
      (result == Color.new(1.0, 1.0, 1.0)).should be_true
    end

    it "shades w/ eye @ 0 deg, light @ 45 deg" do
      material = Material.new
      position = Point.new 0.0, 0.0, 0.0
      eye_v    = Vector.new 0.0, 0.0, -1.0
      normal_v = Vector.new 0.0, 0.0, -1.0
      light    = Light.new Point.new(0.0, 10.0, -10.0), Color.new(1.0, 1.0, 1.0)
      result   = Tracer.phong material, nil, light, position, eye_v, normal_v
      (result == Color.new(0.7364, 0.7364, 0.7364)).should be_true
    end

    it "shades w/ eye @ -45 deg, light @ 45 deg" do
      sq2ov2 : Float64 = Math.sqrt(2.0) / 2.0
      material = Material.new
      position = Point.new 0.0, 0.0, 0.0
      eye_v    = Vector.new 0.0, -sq2ov2, -sq2ov2
      normal_v = Vector.new 0.0, 0.0, -1.0
      light    = Light.new Point.new(0.0, 10.0, -10.0), Color.new(1.0, 1.0, 1.0)
      result   = Tracer.phong material, nil, light, position, eye_v, normal_v
      (result == Color.new(1.6364, 1.6364, 1.6364)).should be_true
    end

    it "shades w/ eye @ 0 deg, light behind solid" do
      material = Material.new
      position = Point.new 0.0, 0.0, 0.0
      eye_v    = Vector.new 0.0, 0.0, -1.0
      normal_v = Vector.new 0.0, 0.0, -1.0
      light    = Light.new Point.new(0.0, 0.0, 10.0), Color.new(1.0, 1.0, 1.0)
      result   = Tracer.phong material, nil, light, position, eye_v, normal_v
      (result == Color.new(0.1, 0.1, 0.1)).should be_true
    end

    it "returns ambient light when object in shadow" do
      material = Material.new
      position = Point.new 0.0, 0.0, 0.0
      eye_v    = Vector.new 0.0, 0.0, -1.0
      normal_v = Vector.new 0.0, 0.0, -1.0
      light    = Light.new Point.new(0.0, 0.0, -10.0), Color.new(1.0, 1.0, 1.0)
      result   = Tracer.phong material, nil, light, position, eye_v, normal_v, true
      (result == Color.new(0.1, 0.1, 0.1)).should be_true
    end
  end
end
