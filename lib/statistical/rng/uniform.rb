require 'statistical/exceptions'
require 'statistical/distribution/uniform'

module Statistical
  module Rng
    class Uniform
      attr_reader :lower, :upper, :generator

      def initialize(dobj = nil, seed = Random.new_seed)
        unless dobj.nil? or dobj.is_a?(Statistical::Distribution::Uniform)  
          raise TypeError, "Expected Distribution object or nil, found #{dobj.class}"
        end
        dobj = Statistical::Distribution::Uniform.new if dobj.nil?
        @generator = Random.new(seed)
        @lower = dobj.lower
        @upper = dobj.upper
        @sdist = dobj
      end

      def rand
        @lower + @generator.rand * (@upper - @lower)
      end

      def eql?(other)
        return false unless other.is_a?(self.class)
        return false unless @lower == other.lower && @upper == other.upper
        @generator == other.generator
      end

      def type
        @sdist.class
      end

      alias == eql?
    end
  end
end
