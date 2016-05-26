require 'statistical/exceptions'
require 'statistical/distribution/uniform'

module Statistical
  module Rng
    # Companion RNG class for the continuous uniform distribution. Requires a
    #   distrbution object of the corresponding distribution
    #
    # @author Vaibhav Yenamandra
    #
    # @attr_reader [Numeric] lower The lower bound of the uniform distribution.
    # @attr_reader [Numeric] upper The upper bound of the uniform distribution.
    class Uniform
      attr_reader :lower, :upper, :generator

      def initialize(dobj = nil, seed = Random.new_seed)
        unless dobj.nil? || dobj.is_a?(Statistical::Distribution::Uniform)
          raise TypeError,
                "Expected Distribution object or nil, found #{dobj.class}"
        end
        dobj = Statistical::Distribution::Uniform.new if dobj.nil?
        @generator = Random.new(seed)
        @lower = dobj.lower
        @upper = dobj.upper
        @sdist = dobj
      end

      # Return the next random number from the sequence
      #
      # @author Vaibhav Yenamandra
      #
      # @return next random number in the sequence
      def rand
        @lower + @generator.rand * (@upper - @lower)
      end

      # Compare against another rng to see if they are the same
      #
      # @author Vaibhav Yenamandra
      #
      # @return [Boolean] true if and only if, source distributions are the
      #   same and the prng has the same initial state
      def eql?(other)
        return other.is_a?(self.class) &&
               @lower == other.lower &&
               @upper == other.upper &&
               @generator == other.generator
      end

      # Return the type of the source distribution
      #
      # @author Vaibhav Yenamandra
      #
      # @return [Statistical::Distribution::Uniform] source distribution's type
      def type
        @sdist.class
      end

      alias == eql?
      private :eql?
    end
  end
end
