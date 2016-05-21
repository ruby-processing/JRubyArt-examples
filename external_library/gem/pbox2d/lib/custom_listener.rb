# A custom listener allows us to get the physics engine to
# to call our code, on say contact (collisions)
class CustomListener
  include ContactListener

  def begin_contact(cp)
    # Get both fixtures
    f1 = cp.getFixtureA
    f2 = cp.getFixtureB
    # Get both bodies
    b1 = f1.getBody
    b2 = f2.getBody
    # Get our objects that reference these bodies
    o1 = b1.getUserData
    o2 = b2.getUserData
    return unless [o1, o2].all? { |obj| obj.respond_to?(:change) }
    o1.change
    o2.change
  end

  def end_contact(_cp)
  end

  def pre_solve(_cp, _m)
  end

  def post_solve(_cp, _ci)
  end
end
