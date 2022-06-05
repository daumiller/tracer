require "./Solid"

module Tracer
  class Intersection
    property distance : Float64
    property solid : Solid

    def initialize(@distance : Float64, @solid : Solid)
    end

    def self.hit(intersections : Array(Intersection)) : Intersection|Nil
      return nil unless intersections.size

      lowest_nn = Float64::MAX
      lowest_nn_idx = -1
      intersections.each_with_index do |inter, index|
        next if inter.distance < 0.0
        next if inter.distance > lowest_nn
        lowest_nn = inter.distance
        lowest_nn_idx = index
      end

      return nil unless (lowest_nn_idx > -1)
      return intersections[lowest_nn_idx]
    end
  end
end
