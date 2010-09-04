$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))


require "../lib/chippunk"

class BaseLine < Chippunk::StaticObject
  
  def initialize
    super
    @size, @width, @height = 50, 50, 50 
    @body = CP::Body.new(CP::INFINITY,CP::INFINITY)
    @body.pos = CP::Vec2.new(1024/2, 740)
    @shape = CP::Shape::Segment.new(@body, CP::Vec2.new(-500,0), CP::Vec2.new(500,0), 0.0)
    #@shape = CP::Shape::Poly.new(@body, [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)], CP::Vec2.new(0,0))
    @shape.e = 1
    @shape.u = 1
    @shape.collision_type = :floor
  end
end

class Entity < Chippunk::Object
  
  def initialize
    super
    @size, @width, @height = 50, 50, 50 
    @body = CP::Body.new(10.0,CP::INFINITY)
    @body.pos = CP::Vec2.new(500,0)
    @body.vel = CP::Vec2.new(0,0)
    @shape = CP::Shape::Circle.new(@body, @size / 2, CP::Vec2.new(0,0))
    @shape.e = 0.5
    @shape.u = 0.8
    @shape.collision_type = :ball
  end
end

class Game < Gosu::Window 
  
  include Chippunk::Helper::Objects
  
  def initialize
    super(1024, 768, false)
    self.caption = "WORLD!!"
    
    @world = Chippunk::World.new
    @world.gravity = CP::Vec2.new(0, 0.1)
    
    @base_line = BaseLine.new
    @entity = Entity.new
    
    balls = Array.new(10) do |n|
      circle(rand(20)+5, rand(30)+5, 300) do |ball|
        ball.position = [300+10*n, 10]
        ball.elasticity = 0.5
      end
    end
    @world.add_objects(@base_line, @entity, *balls)
  end
  
  def centerx
    0
  end
  
  def centery
    0
  end
  
  def update
    @world.step(1)
  end
  
  def draw
    self.draw_quad(0, 0, Gosu::Color.new(0xff002040), 1024, 0, Gosu::Color.new(0xff002040), 0, 768, Gosu::Color.new(0xff002040), 1024, 768, Gosu::Color.new(0xff002040), 0)
    @world.draw(self)
  end
end

window = Game.new.show

