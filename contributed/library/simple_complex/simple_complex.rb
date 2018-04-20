require 'forwardable'

# A simpler complex class
class SimpleComplex
  extend Forwardable
  attr_reader :complex
  def_delegator :@complex, :to_s
  def_delegators :@complex, :abs, :+, :*

  def initialize(real, complex)
    @complex = Complex(real, complex)
  end

  def add!(other)
    @complex += other.complex
  end

  def square!
    @complex *= complex
  end
end
