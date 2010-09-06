$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "../lib/chippunk"

module Dimensions
  Mothership = [
      [-30.0, 60.0],
      [30, 60.0],
      [30, -60],
      [-30, -60]
  ]
end

class Game < Gosu::Window 
  
  include Chippunk::Builder
  
  def initialize
    super(1024, 768, false)
    self.caption = "WORLD!!"
  
    @world = Chippunk::World.new do |config|
      config.gravity = CP::Vec2.new(0.0, 1800.0)
      config.damping = 0.3
      config.iterations = 20
      config.substeps = 20
      config.dt = (1.0/60) / 20
    end
    
    ground = build_segment_object(1024, CP::INFINITY, CP::INFINITY) do |config|
      config.position = [1024/2, 760]
      config.friction = 0.9
      config.static!
    end
    
    @ship = build_polygon_object(Dimensions::Mothership, 10, 900) do |ship|
      ship.position = [600 + rand(300), 10 + rand(30)]
      ship.elasticity = 0.5
      ship.friction = 0.3
    end
    
    balls = Array.new(50) do |n|
      build_circle_object(rand(30)+10, rand(3)+1, 0.4) do |ball|
        ball.position = [200+rand(400), 10 + rand(10)]
        ball.elasticity = 0.9
        ball.friction = 0.1
      end
    end
    
    @world.add_objects(@ship)
    @world.add_objects(*balls)
    @world.add_objects(ground)
  end
    
  def update
    @world.update do 
      @ship.body.reset_forces
      @ship.body.apply_force(vec2(0, -18000), vec2(0,0))
      if self.button_down?(Gosu::KbUp)
        @ship.body.apply_force(vec2(0, -10000), vec2(0,0))
        puts "btn down"
      end
      if self.button_down?(Gosu::KbDown)
        @ship.body.apply_force(vec2(0, 9000), vec2(0,0))
      end
      if self.button_down?(Gosu::KbLeft)
        @ship.body.apply_force(vec2(-9000,0), vec2(0,0))
      end
      if self.button_down?(Gosu::KbRight)
        @ship.body.apply_force(vec2(9000,0), vec2(0,0))
      end
      
      puts @ship.body.vel
    end
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    when Gosu::KbUp
      #@ship.body.apply_force(vec2(0, -10), vec2(0,0))
    end
  end

  def draw
    self.draw_quad(0, 0, Gosu::Color.new(0xff002040), 1024, 0, Gosu::Color.new(0xff002040), 0, 768, Gosu::Color.new(0xff002040), 1024, 768, Gosu::Color.new(0xff002040), 0)
    @world.draw(self)
  end
end

window = Game.new.show

