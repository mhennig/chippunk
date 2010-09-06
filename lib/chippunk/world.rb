module Chippunk
  class World
    attr_reader :space, :objects
    attr_accessor :dt, :substeps

    def initialize(&block)
      @space = CP::Space.new
      @objects = []
      yield(self) if block_given?
    end

    def method_missing(method, *args, &block)
      @space.send(method, *args, &block)
    end

    def add_object(obj)
      obj.world = self
      obj.shape.obj = obj
      @space.add_shape(obj.shape)
      @space.add_body(obj.shape.body) unless obj.static?
      @objects << obj
    end

    def add_objects(*objects)
      objects.each{ |obj| self.add_object(obj) }
    end
    
    def update(&block)
      @substeps.times do
        @objects.each{ |o| o.body.reset_forces }
        yield(self) if block_given?
        @space.step(@dt)
      end
    end
    
    def draw(canvas)
      @objects.each{ |obj| obj.draw(canvas) }
    end
  end
end

