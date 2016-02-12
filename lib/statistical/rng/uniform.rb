require 'statistical/exceptions'
require 'statistical/distribution/uniform'

module Statistical
  module Rng
    class Uniform
      attr_reader :lower, :upper, :generator

      def initialize(seed = Random.new_seed, dist_obj)
        raise ValueError, %q{distribution object must be of same type
          as self} unless dist_obj.is_a?(Statistical::Distribution::Uniform)
        
        @generator = Random.new(seed)
        @lower = dist_obj.lower
        @upper = dist_obj.upper
      end

      def rand
        @lower + @generator.rand * (@upper - @lower)
      end

      def eql?(other)
        return false unless other.is_a?(Statistical::Rng::Uniform)
        return false unless @lower == other.lower && @upper == other.upper
        @generator == other.generator
      end

      def type
        dist_obj.class
      end

      alias == eql?
    end
  end
end
