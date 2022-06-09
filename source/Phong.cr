require "./Color"
require "./Material"
require "./Light"
require "./V4"

module Tracer
  def self.phong(material : Material, light : Light, position : Point, eye_v : Vector, normal_v : Vector, in_shadow : Bool = false) : Color
    light_vector     : Vector  = Vector.from((light.position - position).normalize)
    light_dot_normal : Float64 = light_vector.dot normal_v

    effective_color : Color = material.color.blend light.color
    ambient_color   : Color = effective_color * material.ambient
    return ambient_color if in_shadow

    diffuse_color   : Color = Color.new 0.0, 0.0, 0.0
    specular_color  : Color = Color.new 0.0, 0.0, 0.0

    if light_dot_normal >= 0.0
      diffuse_color             = effective_color * material.diffuse * light_dot_normal
      reflect_vector  : Vector  = Vector.from(light_vector * -1.0).reflect(normal_v)
      reflect_dot_eye : Float64 = reflect_vector.dot(eye_v)
      if reflect_dot_eye > 0.0
        factor         : Float64 = reflect_dot_eye ** material.shininess
        specular_color           = light.color * material.specular * factor
      end
    end

    return ambient_color + diffuse_color + specular_color
  end
end
