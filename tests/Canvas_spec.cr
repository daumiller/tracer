# crystal spec tests/Canvas_spec.cr -v --error-trace --link-flags $(pwd)/stb_image_write.a
require "spec"
require "../source/Tracer"

describe Tracer::Canvas do
  it "initializer" do
    background = Tracer::Color.new 0.25, 0.50, 1.00
    foreground = Tracer::Color.new 0.25, 0.25, 0.25
    cnv = Tracer::Canvas.new 900, 640, background.to_u32
    cnv.width.should eq(900)
    cnv.height.should eq(640)
    got_val = cnv.get(10,10)
    (Tracer::Color.new(cnv.get(10,10)) == background).should be_true
    (Tracer::Color.new(cnv.get(10,10)) == foreground).should be_false
  end

  it "get/set pixels" do
    cnv = Tracer::Canvas.new 128, 128
    background = Tracer::Color.new 0.0, 0.0, 0.0
    pen_color  = Tracer::Color.new 0.0, 0.0, 0.8
    
    got_color = Tracer::Color.new(cnv.get(0,0))
    (got_color == background).should be_true
    (got_color == pen_color).should be_false
    got_color = Tracer::Color.new(cnv.get(10,11))
    (got_color == background).should be_true
    (got_color == pen_color).should be_false

    cnv.set 10, 11, pen_color.to_u32

    got_color = Tracer::Color.new(cnv.get(0,0))
    (got_color == background).should be_true
    (got_color == pen_color).should be_false
    got_color = Tracer::Color.new(cnv.get(10,11))
    (got_color == background).should be_false
    (got_color == pen_color).should be_true
  end
end
