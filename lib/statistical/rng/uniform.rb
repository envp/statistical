require 'statistical/exceptions'

module Statistical
  module Rng
    class Uniform
      attr_reader :lower, :upper, :generator

      def initialize(seed = Random.new_seed, lower = 0.0, upper = 1.0)
        @generator = Random.new(seed)
        @lower = [lower, upper].min
        @upper = [lower, upper].max
      end

      def rand
        lower + @generator.rand * (upper - lower)
      end

      def eql?(other)
        return false unless other.is_a?(Statistical::Rng::Uniform)
        return false unless @lower == other.lower && @upper == other.upper
        @generator == other.generator
      end

      alias == eql?
    end
  end
end
