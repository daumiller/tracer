# crystal run source/main.cr --link-flags $(pwd)/stb_image_write.a
# crystal spec tests -v --error-trace --link-flags $(pwd)/stb_image_write.a
require "./Tracer"
include Tracer

canvas        = Canvas.new 128, 128, 0x00000000
penclr        = Color.new(1.0, 0.0, 1.0).to_u32
sphere        = Sphere.new M4x4.scale(1.998, 1.998, 1.998)
camera_origin = Point.new 0.0, 0.0, -2.0

(0_u32...128_u32).each do |x|
  (0_u32...128_u32).each do |y|
    ray = Ray.new camera_origin, Vector.new(x.to_f64 - 64.0, y.to_f64 - 64.0, 2.0)
    next if ray.intersections(sphere).size == 0
    canvas.set x, y, penclr
  end
end
canvas.write "sphere.png"
