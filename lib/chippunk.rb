require "rubygems"
require "gosu"
require 'chipmunk'

module Chippunk
  
  module Helper
    
    module Shapes
      def circle_shape()
        
      end
    end
    
    module Objects
      
      def circle(size, mass=0, inertia=0, offset=[0,0], &block)
        obj = Chippunk::Object.new
        obj.shape = CP::Shape::Circle.new(obj.body(mass, inertia), size/2, CP::Vec2.new(0,0))
        yield(obj) if block_given?
        obj
      end
      
    end
  end
  
  class World
    attr_reader :space, :objects
    
    def initialize
      @space = CP::Space.new
      @objects = []
    end
    
    def method_missing(method, *args, &block)
      @space.send(method, *args, &block)
    end
    
    def add_object(obj)
      @space.add_shape(obj.shape)
      @space.add_body(obj.shape.body) unless obj.static?
      @objects << obj
    end
    
    def add_objects(*objects)
      objects.each{ |obj| self.add_object(obj) }
    end
    
    def draw(canvas)
      @objects.each{ |obj| obj.draw(canvas) }
    end
    
  end
  
  class Object
    attr :body
    attr_reader :shape, :view
    
    def initialize(*args)
      super
      @is_static = false
    end
    
    def shape=(shape)
      @shape ||= shape
    end
    
    def body(mass=0, inertia=0)
      @body ||= CP::Body.new(mass, inertia)
    end
    
    def position=(pos)
      x, y = pos.values_at(0, 1)
      body.pos = CP::Vec2.new(x.to_f,y.to_f)
    end
    
    def mass=(m)
      body.mass = m
    end
    
    def inertia=(i)
      body.i = 0
    end
    
    def velocity=(x_direction, y_direction)
      body.vel = CP::Vec2(x_direction, y_direction)
    end
    
    def elasticity=(e)
      shape.e = e
    end
    
    def friction=(u)
      shape.u = u
    end
    
    def collision_type=(type)
      shape.collision_type = type.to_sym
    end
    
    def static?
      @is_static
    end
    
    def draw(canvas)
      unless view.respond_to?(:draw)
        @shape.draw(canvas)
      end
    end
  end
  
  class StaticObject < Chippunk::Object
    def initialize(*args)
      super
      @is_static = true
    end
  end
  
end

module CP
    
  module Shape
    
    class Segment
      attr_reader :a, :b, :radius
      alias_method :orig_init, :initialize
      
      def initialize(body, a, b, radius)
        @a, @b, @radius = a, b, radius
        orig_init(body, a, b, radius)
      end
      
      def draw(canvas)
        v1 = body.p + self.a.rotate(body.rot)
        v2 = body.p + self.b.rotate(body.rot)
        canvas.draw_line(v1.x, v1.y, Gosu::red, v2.x, v2.y, Gosu::red)
      end
    end
    
    class Circle
      attr_reader :radius, :center
      alias_method :orig_init, :initialize
      
      def initialize(body, radius, center)
        @radius, @center = radius, center
        orig_init(body,radius,center)
      end
      
      def draw(canvas)
        c = body.p + self.center.rotate(body.rot)
        a = body.a
        segs = 16
        coef = 2.0*Math::PI/(segs.to_f)
        
        points = Array.new(segs) do |n|
          rads = n*coef
          [radius*Math.cos(rads+a) + c.x, radius*Math.sin(rads + a) + c.y]
        end
        
        points.each_cons(2) do |v1,v2|
          canvas.draw_line(v1[0], v1[1], Gosu::red, v2[0], v2[1], Gosu::red)
        end
      end
    end
    
    class Poly
      attr_reader :verts, :offset
      alias_method :orig_init, :initialize
      
      def initialize(body, verts, offset)
        @verts, @offset = verts, offset
        orig_init(body, verts, offset)
      end
      
      def draw(canvas)
      end
    end
  end
end