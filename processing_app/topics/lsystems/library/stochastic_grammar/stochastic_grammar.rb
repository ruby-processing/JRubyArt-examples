########################
# stochastic_grammar.rb
# unweighted rules accepted
# with default weight = 1
# complex stochastic rule
########################
class StochasticGrammar
  PROB = 1
  attr_accessor :axiom, :srules

  def initialize(axiom)
    @axiom = axiom
  end

  ######################################################
  # randomly selects a rule (with a weighted probability)
  #####################################################

  def stochastic_rule(rules)
    total = rules.values.reduce(&:+)
    srand
    chance = rand(0..total)
    rules.each do |item, weight|
      return item unless chance > weight
      chance -= weight
    end
  end

  def rule?(pre)
    @srules.key?(pre)
  end

  def add_rule(pre, rule, weight = 1.0) # default weighting 1
    @srules ||= Hash.new { |h, k| h[k] = 1 }
    if rule?(pre)                       # add to existing hash
      srules[pre][rule] = weight
    else
      srules[pre] = { rule => weight }  # store new hash with pre key
    end
  end

  def new_production(prod)  # note the use of gsub!
    prod.gsub!(/./) do |ch|
      rule?(ch) ? stochastic_rule(srules[ch]) : ch
    end
  end

  def generate(repeat = 0)
    prod = axiom
    repeat.times { prod = new_production(prod) }
    prod
  end
end
