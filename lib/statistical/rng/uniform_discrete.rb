require 'statistical/distribution/uniform_discrete'

module Statistical
  module Rng
    # Companion RNG class for the continuous uniform distribution. Requires a
    #   distrbution object of the corresponding distribution
    #
    # @author Vaibhav Yenamandra
    #
    # @attr_reader [Numeric] lower The lower bound of the uniform distribution
    # @attr_reader [Numeric] upper The upper bound of the uniform distribution
    # @attr_reader [Numeric] generator The prng created with `seed` for usage
    #   as a source of randomness to base the current RNG on
    class UniformDiscrete
      attr_reader :generator, :lower, :upper
      # Uniform Discrete RNG constructor
      #
      # @author Vaibhav Yenamandra
      #
      # @param [Statistical::Distribution::UniformDiscrete] dobj The
      #   distribution object to be used to create the RNG
      # @param [Random] seed Seed to set the PRNG initial state
      def initialize(dobj, seed = Random.new_seed)
        unless dobj.nil? || dobj.is_a?(Statistical::Distribution::UniformDiscrete)
          raise TypeError,
                "Expected Distribution object or nil, found #{dobj.class}"
        end
        @generator = Random.new(seed)
        @lower = dobj.lower
        @upper = dobj.upper
        @sdist = dobj
      end

      # Return the next random number from the sequence using Ruby's `rand`
      #
      # @author Vaibhav Yenamandra
      #
      # @return next random number in the sequence
      def rand
        n = members.count
        return members[@generator.rand(n)]
      end

      # Compare against another rng. Compares distribution parameters and
      # initial state of rngs to assert equality
      #
      # @private
      # @author Vaibhav Yenamandra
      # @return true if and only if, source distributions are the same and the
      #   prng has the same initial state
      def eql?(other)
        return other.is_a?(self.class) &&
               members == other.members &&
               @generator == other.generator
      end

      # Return the type of the source distribution
      #
      # @author Vaibhav Yenamandra
      #
      # @return source distribution's type
      def type
        @sdist.class
      end

      # A call to expose the underlying distribution's support set
      #
      # @return The elements over which the distribution exists
      def members
        return @sdist.support
      end

      alias :== :eql?
      private :eql?
    end
  end
end
