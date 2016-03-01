require 'statistical/exceptions'
require 'statistical/distribution/uniform_discrete'

module Statistical
  module Rng
    class UniformDiscrete
      attr_reader :generator, :lower, :upper, :step

      # Companion RNG class for the continuous uniform distribution. Requires a
      #   distrbution object of the corresponding distribution
      #
      # @author Vaibhav Yenamandra
      #
      # @attr_reader [Numeric] lower The lower bound of the uniform distribution.
      # @attr_reader [Numeric] upper The upper bound of the uniform distribution.
      def initialize(dobj = nil, seed = Random.new_seed)
        unless dobj.nil? || dobj.is_a?(Statistical::Distribution::UniformDiscrete)
          raise TypeError, "Expected Distribution object or nil, found #{dobj.class}"
        end
        dobj = Statistical::Distribution::UniformDiscrete.new if dobj.nil?
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
        mem = members
        n = mem.count
        return mem[@generator.rand(n)]
      end

      # Compare against another rng to see if they are the same
      #
      # @author Vaibhav Yenamandra
      #
      # @return true if and only if, source distributions are the same and the
      #   prng has the same initial state
      def eql?(other)
        return other.is_a?(self.class) &&
               @lower == other.lower &&
               @upper == other.upper &&
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

      alias == eql?
      private :eql?
    end
  end
end
