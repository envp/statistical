require 'statistical/exceptions'
require 'statistical/distribution/two_point'

module Statistical
  module Rng
    class TwoPoint
      attr_reader :generator, :p, :q, :states

      # Companion RNG class for the two-point distribution. Requires a
      # distrbution object of the corresponding type. Defaults to the standard
      # bernoulli if no arguments are given
      #
      # @author Vaibhav Yenamandra
      #
      # @attr_reader [Float] p Probability of success state
      # @attr_reader [Float] q Probability of failure state
      # @attr_reader [Hash] states Possible states that the RNG can take up
      # @attr_reader [Random] generator The PRNG being used for randomness
      def initialize(dobj = nil, seed = Random.new_seed)
        unless dobj.nil? || dobj.is_a?(Statistical::Distribution::TwoPoint)
          raise TypeError, 
            "Expected Distribution object or nil, found #{dobj.class}"
        end
        dobj = Statistical::Distribution::TwoPoint.new if dobj.nil?
        @generator = Random.new(seed)
        @sdist = dobj
        @p = dobj.p
        @q = dobj.q
        @states = dobj.states
      end

      # Return the next random number from the sequence following the given 
      # distribution
      #
      # @return next random number in the sequence
      def rand
        return @sdist.quantile(@generator.rand)
      end

      # Compare against another rng to see if they are the same
      #
      # @return [Boolean] true if and only if, source distributions are the same 
      #   and the prng has the same initial state
      def eql?(other)
        return other.is_a?(self.class) &&
          @p = other.p &&
          @states == other.states &&
          @generator == other.generator
      end

      # Return the type of the source distribution
      #
      # @return source distribution's type
      def type
        @sdist.class
      end

      # The support set over which the distribution exists
      def support
        @sdist.support
      end

      alias_method :==, :eql?
      private :eql?
    end
  end
end
