# crystal run source/main.cr --link-flags $(pwd)/stb_image_write.a
# crystal spec tests -v --error-trace --link-flags $(pwd)/stb_image_write.a
require "./Tracer"
include Tracer

canvas        = Canvas.new 128, 128, 0x00000000
sphere        = Sphere.new M4x4.scale(1.0), Material.new(Color.new(1.0, 0.2, 0.5))
camera_origin = Point.new 0.0, 0.0, -5.0
light         = Light.new Point.new(-5.0, -10.0, -10.0), Color.new(1.0, 1.0, 1.0)

pixel_world_scale = 7.0 / 128.0
half_world_scale = 3.5

(0_u32...128_u32).each do |x|
  world_x = (x.to_f64 * pixel_world_scale) - half_world_scale
  (0_u32...128_u32).each do |y|
    world_y = (y.to_f64 * pixel_world_scale) - half_world_scale

    ray = Ray.new camera_origin, (Vector.new(world_x, world_y, 10.0) - camera_origin).normalize
    hit = Intersection.hit(ray.intersections(sphere))
    next if hit.nil?

    position  = Point.from(ray.position hit.distance)
    normal_v  = Vector.from(hit.solid.normal_at position)
    eye_v     = Vector.from(-ray.direction)
    hit_color = Tracer.phong hit.solid.material, light, position, eye_v, normal_v

    canvas.set x, y, hit_color.to_u32
  end
end
canvas.write "sphere.png"
