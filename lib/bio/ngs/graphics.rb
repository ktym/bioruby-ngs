#
#  
#
# Copyright:: Copyright (C) 2011
#     Francesco Strozzi <francesco.strozzi@gmail.com>
# License:: The Ruby License
#
#

require 'rubyvis'

module Bio
  module Ngs
    class Graphics
      
        def self.draw_area(data,width,height,out=nil,title_label="", x_label="", y_label="",x_padding=15, n_ticks=10)
          point = 0
          max = data.max + 10
          data = data.map do |d|
            point += 1
            OpenStruct.new({:x=> point, :y=> d})
          end
          x = pv.Scale.linear(data, lambda {|d| d.x}).range(0, width)
          y = pv.Scale.linear(0, max).range(0, height);
          
          #The root panel
          vis = pv.Panel.new() do
            width width
            height height
            bottom 20
            left 50
            right 10
            top 5

          # Y-axis and ticks
            rule do
              data y.ticks(n_ticks)
              bottom(y)
              stroke_style {|d| d!=0 ? "#eee" : "#000"}
              label(:anchor=>"left") {
                puts y.inspect
                text y.tick_format
              }
            end

          # X-axis and ticks.
            rule do
              data x.ticks()
              visible {|d| d!=0}
              left(x)
              bottom(-5)
              height(5)
              label(:anchor=>'bottom') {
                text(x.tick_format)
              }
            end
            
          #/* The area with top line. */
            area do |a|
              a.data data
              a.bottom(1)
              a.left {|d| x.scale(d.x)}
              a.height {|d| y.scale(d.y)}
              a.fill_style("rgb(121,173,210)")
              a.line(:anchor=>'top') {
                line_width(3)
              }
            end
          end
          
          # panel legend and title
          panel = vis.add(Rubyvis::Panel).
            width(width-x_padding).
            height(height)
            
          panel.anchor('top').add(Rubyvis::Label).
            font("20px sans-serif").
            text(title_label)
          
          panel.anchor('bottom').add(Rubyvis::Label).text(x_label)
          panel.anchor('left').add(Rubyvis::Label).
            text_angle(1.5*Math::PI).
            text(y_label)
          
          
          vis.render();
          
          if out
            File.open(out,"w") {|f| f.write(vis.to_svg) }
          else
            puts vis.to_svg
          end

      end
  
    end
  end
end