# crystal run source/main.cr --link-flags $(pwd)/stb_image.a
# crystal spec tests -v --error-trace --link-flags $(pwd)/stb_image.a
require "./Tracer"
include Tracer

def build_scene : World
  floor = Plane.new
  floor.material.color = Color.new(1.0, 0.9, 0.9)
  floor.material.specular = 0.0
  floor.texture = Canvas.load "tiled-texture-a.png"
  floor.texture_scale = 0.003

  wall_left = Plane.new M4x4.rotation_y(-Math::TAU/8.0) * M4x4.translation(0.0, 0.0, 5.0) * M4x4.rotation_x(Math::TAU/4.0) 
  wall_left.material = Material.new Color.new(0.35, 0.35, 0.35)
  wall_left.material.specular = 0.0
  wall_left.material.reflectivity = 0.7

  wall_right = Plane.new M4x4.rotation_y( Math::TAU/8.0) * M4x4.translation(0.0, 0.0, 5.0) * M4x4.rotation_x(Math::TAU/4.0) 
  wall_right.material = Material.new Color.new(0.75, 0.75, 1.0)
  wall_right.material.specular = 0.0
  wall_right.texture = Canvas.load "tiled-texture-b.png"
  wall_right.texture_scale = 0.005

  left_sphere = Sphere.new
  left_sphere.transform = M4x4.translation(-1.5, 0.33, -0.75) * M4x4.scale(0.33)
  left_sphere.material.color    = Color.new(1.0, 0.8, 1.0)
  left_sphere.material.diffuse  = 0.7
  left_sphere.material.specular = 0.3
  left_sphere.material.reflectivity = 0.2

  middle_sphere = Sphere.new
  middle_sphere.transform = M4x4.translation(-0.5, 1.0, 0.5)
  middle_sphere.material.diffuse  = 0.8
  middle_sphere.material.specular = 0.4
  middle_sphere.texture = Canvas.load "earth.png"

  right_sphere = Sphere.new
  right_sphere.transform = M4x4.translation(1.5, 0.5, -0.5) * M4x4.scale(0.5)
  right_sphere.material.color    = Color.new(0.5, 1.0, 0.1)
  right_sphere.material.diffuse  = 0.7
  right_sphere.material.specular = 0.3
  right_sphere.material.reflectivity = 0.2

  solids = [ floor, wall_left, wall_right, left_sphere, middle_sphere, right_sphere ].map { |solid| solid.as(Solid) }

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
