$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "gosu"
#require 'chipmunk-ffi'
require 'chipmunk'

require 'chippunk/helper.rb'
require 'chippunk/world.rb'
require 'chippunk/object.rb'
require 'chippunk/builder.rb'

unless [].respond_to?(:enum_cons)
  module Enumerable
    alias :enum_cons :each_cons
  end
end

class Numeric
  def radians_to_vec2
    CP::Vec2.new(Math::cos(self), Math::sin(self))
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
        canvas.draw_line(v1.x, v1.y, Gosu::Color.new(0xffff0000), v2.x, v2.y, Gosu::Color.new(0xffff0000))
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
        segs = 20
        coef = 2.0*Math::PI/(segs.to_f)
        
        points = Array.new(segs) do |n|
          rads = n*coef
          [radius*Math.cos(rads+a) + c.x, radius*Math.sin(rads + a) + c.y]
        end
        
        points.enum_cons(2) do |v1,v2|
          canvas.draw_line(v1[0], v1[1], Gosu::Color.new(0xffff0000), v2[0], v2[1], Gosu::Color.new(0xffff0000))
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
        ary = verts.map {|v| body.p + self.offset + v.rotate(body.rot)}
        puts body.rot
        segs = ary.enum_cons(2).to_a << [ary[-1],ary[0]]
        segs.each do |v1,v2|
          canvas.draw_line(v1.x,v1.y,Gosu::Color.new(0xffff0000),v2.x,v2.y,Gosu::Color.new(0xffff0000))
        end
      end
    end
  end
end