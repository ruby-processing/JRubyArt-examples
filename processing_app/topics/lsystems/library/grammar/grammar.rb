# frozen_string_literal: true

############################
# Simple lsystem grammar
############################
class Grammar
  attr_reader :axiom, :rules
  def initialize(axiom, rules)
    @axiom = axiom
    @rules = rules
  end

  def expand(production, iterations, &block)
    production.each_char do |token|
      if rules.key?(token) && iterations.positive?
        expand(rules[token], iterations - 1, &block)
      else
        yield token
      end
    end
  end

  def each(gen)
    expand(axiom, gen) { |token| yield token }
  end

  def generate(gen)
    [].tap do |output|
      each(gen) { |token| output << token }
    end
  end
end
