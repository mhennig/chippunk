module Chippunk
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
    
    def position=(coords)
      x, y = coords.values_at(0, 1)
      body.pos = CP::Vec2.new(x.to_f,y.to_f)
    end
    
    def mass=(m)
      body.mass = m
    end
    
    def angle=(a)
      body.angle = a
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
    
    def static!
      @is_static = true
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