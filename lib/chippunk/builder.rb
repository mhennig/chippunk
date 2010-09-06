require 'chippunk/object.rb'
require 'chippunk/helper.rb'

module Chippunk
  module Builder
    
    include Chippunk::Helper
    
    def build_segment_object(width, mass=0, inertia=0, radius=0.0)
      obj = Chippunk::Object.new
      a = vec2(width/2,0)
      b = vec2(width/2*-1,0)
      obj.shape = CP::Shape::Segment.new(obj.body(mass, inertia), a, b, radius)
      yield(obj) if block_given?
      obj
    end
    
    def build_circle_object(size, mass=0, moment=0, offset=[0,0], &block)
      obj = Chippunk::Object.new
      moment = CP.moment_for_circle(mass, size/2, 0.0, vec2(0,0))
      obj.shape = CP::Shape::Circle.new(obj.body(mass, 100000), size/2, vec2(0,0))
      yield(obj) if block_given?
      obj
    end
    
    def build_polygon_object(list_of_coords, mass=0, inertia=0)
      obj = Chippunk::Object.new
      verts = coords_to_verts(list_of_coords)
      moment = CP.moment_for_poly(mass, verts, vec2(0,0))
      obj.shape = CP::Shape::Poly.new(obj.body(mass, CP::INFINITY), verts, vec2(0,0))
      obj.angle = (3*Math::PI/2.0)
      yield(obj) if block_given?
      obj
    end
    
    def build_rectangle_object(width, height, mass=0, inertia=0)
      
    end
    
  end
end