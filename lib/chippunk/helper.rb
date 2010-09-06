
require "pp"

module Chippunk  
  module Helper
    
    include Enumerable
    
    def coords_to_verts(list_of_coords)
      verts = []
      
      #puts list_of_coords
      
      #puts " + + + + + + +  +"
      
      list_of_coords.flatten.each_slice(2) do |coords|
        x,y = coords.values_at(0,1)
        verts.push(vec2(x,y))
      end
      #puts verts
      #exit
      verts
    end
  end
end