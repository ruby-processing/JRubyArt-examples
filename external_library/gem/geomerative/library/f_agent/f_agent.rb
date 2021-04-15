# frozen_literal: true
# FontAgent class handles motion and display
class FontAgent
  include Processing::Proxy # gives java 'inner class like' access to App
  attr_reader :loc, :offset, :increment

  def initialize(loc:, increment:)
    @loc = loc.copy
    @offset = Vec2D.new
    @increment = increment
  end

  def motion
    @offset += increment
    hw = width / 2
    hh = height / 2
    loc.dist(Vec2D.new((noise(offset.x) + 1) * hw, (noise(offset.y) + 1) * hh))
  end

  def display(xr:, yr:, m_point:)
    no_stroke
    fill(255, 100)
    dia = (150 / m_point) * 7
    # to get weird non-deterministic behaviour of original, created by use of
    # negative inputs to a random range surely not intended, use original:-
    # ellipse(loc.x + random(-xr, xr), loc.y + random(-yr, yr), dia, dia)
    xr *= -1 if xr.negative? # guards against an invalid hi..low range
    yr *= -1 if yr.negative?
    ellipse(loc.x + rand(-xr..xr), loc.y + rand(-yr..yr), dia, dia)
  end
end
