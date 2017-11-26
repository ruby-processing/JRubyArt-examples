require 'yaml'

# yaml bubble reader
class BubbleReader
  attr_reader :hash

  def read(path)
    @hash = YAML.load_file(path)
  end
end
