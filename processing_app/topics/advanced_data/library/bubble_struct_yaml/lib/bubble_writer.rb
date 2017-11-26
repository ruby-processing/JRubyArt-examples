require 'yaml'

# yaml bubble writer
class BubbleWriter
  attr_reader :hash

  def initialize(type:, data:)
    @hash = { type => data }
  end

  def write(path)
    File.write(path, hash.to_yaml)
  end
end
