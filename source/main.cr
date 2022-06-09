# crystal run source/main.cr --link-flags $(pwd)/stb_image_write.a
# crystal spec tests -v --error-trace --link-flags $(pwd)/stb_image_write.a
require "./Tracer"
include Tracer

def build_scene : World
  floor = Sphere.new
  floor.transform = M4x4.scale(10.0, 0.01, 10.0)
  floor.material.color = Color.new(1.0, 0.9, 0.9)
  floor.material.specular = 0.0

  left_wall = Sphere.new
  left_wall.transform = M4x4.translation(0.0, 0.0, 5.0) *
                        M4x4.rotation_y(-Math::TAU/8.0) *
                        M4x4.rotation_x( Math::TAU/4.0) *
                        M4x4.scale(10.0, 0.01, 10.0)
  left_wall.material = floor.material

  right_wall = Sphere.new
  right_wall.transform = M4x4.translation(0.0, 0.0, 5.0) *
                         M4x4.rotation_y( Math::TAU/8.0) *
                         M4x4.rotation_x( Math::TAU/4.0) *
                         M4x4.scale(10.0, 0.01, 10.0)
  right_wall.material = floor.material

  left_sphere = Sphere.new
  left_sphere.transform = M4x4.translation(-1.5, 0.33, -0.75) * M4x4.scale(0.33)
  left_sphere.material.color    = Color.new(1.0, 0.8, 1.0)
  left_sphere.material.diffuse  = 0.7
  left_sphere.material.specular = 0.3

  middle_sphere = Sphere.new
  middle_sphere.transform = M4x4.translation(-0.5, 1.0, 0.5)
  middle_sphere.material.color    = Color.new(1.0, 0.1, 0.5)
  middle_sphere.material.diffuse  = 0.7
  middle_sphere.material.specular = 0.3

  right_sphere = Sphere.new
  right_sphere.transform = M4x4.translation(1.5, 0.5, -0.5) * M4x4.scale(0.5)
  right_sphere.material.color    = Color.new(0.5, 1.0, 0.1)
  right_sphere.material.diffuse  = 0.7
  right_sphere.material.specular = 0.3

  solids = [floor, left_wall, right_wall, left_sphere, middle_sphere, right_sphere].map { |sphere| sphere.as(Solid) }

  light0 = Light.new Point.new(-10.0, 10.0, -10.0), Color.new(1.0, 1.0, 1.0)
  light1 = Light.new Point.new(  8.0,  6.0, -10.0), Color.new(0.25, 0.25, 0.25)
  lights = [ light0, light1 ]

  World.new lights, solids
end

def render(world : World, camera : Camera, filename : String)
  canvas = Canvas.new camera.width, camera.height, 0x00000000

  (0_u32...camera.width).each do |x|
    (0_u32...camera.height).each do |y|
      ray = camera.ray_for_pixel x, y
      color = world.color_at ray
      canvas.set x, y, color.to_u32
    end
  end

  canvas.write filename
end

camera_transform = M4x4.view_transform(
  Point.new(0.0, 1.5, -5.0), # camera position ("from")
  Point.new(0.0, 1.0,  0.0), # camera pointing at ("to")
  Vector.new(0.0, 1.0, 0.0), # up direction ("up")
)
camera = Camera.new 512_u32, 512_u32, Math::TAU/6.0, camera_transform
world = build_scene
render world, camera, "scene.png"
