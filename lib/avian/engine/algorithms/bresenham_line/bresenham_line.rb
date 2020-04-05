module BresenhamLine
  def self.iterate_line(p1, p2, &blk)
    x1, y1 = p1.x, p1.y
    x2, y2 = p2.x, p2.y

    steep = (y2 - y1).abs > (x2 - x1).abs

    if steep
      x1, y1 = y1, x1
      x2, y2 = y2, x2
    end

    if x1 > x2
      x1, x2 = x2, x1
      y1, y2 = y2, y1
    end

    deltax = x2 - x1
    deltay = (y2 - y1).abs
    error = deltax / 2
    ystep = y1 < y2 ? 1 : -1

    y = y1
    x1.upto(x2) do |x|
      pixel = steep ? [y,x] : [x,y]
      blk.call(*pixel)
      error -= deltay
      if error < 0
        y += ystep
        error += deltax
      end
    end
  end
end
