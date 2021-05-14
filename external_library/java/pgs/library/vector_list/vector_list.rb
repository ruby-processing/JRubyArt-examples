java_import 'java.util.ArrayList'
java_import 'processing.core.PVector'

class VectorList
  attr_reader :array_list
  def initialize
    @array_list = ArrayList.new
  end

  def <<(val)
    array_list.add(PVector.new(val.x, val.y, val.z))
  end
end
