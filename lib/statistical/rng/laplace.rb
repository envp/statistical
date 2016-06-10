require 'statistical/exceptions'
require 'statistical/distribution/laplace'

module Statistical
  module Rng
    # Companion RNG class for the continuous uniform distribution. Requires a
    #   distrbution object of the corresponding distribution
    #
    # @author Vaibhav Yenamandra
    #
    # @attr_reader [Numeric] scale Scale parameter of the Laplace distribution.
    # @attr_reader [Numeric] location Location parameter to determine where the
    #   distribution is centered / where the mean lies at
    class Laplace
      attr_reader :generator, :scale, :location

      def initialize(dobj = nil, seed = Random.new_seed)
        unless dobj.nil? || dobj.is_a?(Statistical::Distribution::Laplace)
          raise TypeError, 
            "Expected Distribution object or nil, found #{dobj.class}"
        end
        dobj = Statistical::Distribution::Laplace.new if dobj.nil?
        @generator = Rng::Uniform.new(Distribution::Uniform.new, seed)
        @scale = dobj.scale
        @location = dobj.location
        @sdist = dobj
      end

      # Return the next random number from the sequence
      #
      # @return next random number in the sequence
      def rand
        return @sdist.quantile(@generator.rand)
      end

      # Compare against another rng to see if they are the same
      #
      # @return true if and only if, source distributions are the same and the
      #   prng has the same initial state
      def eql?(other)
        return other.is_a?(self.class) &&
          other.generator == @generator &&
          other.location == @location &&
          other.scale == @scale
      end

      # Return the type of the source distribution
      #
      # @return source distribution's type
      def type
        @sdist.class
      end

      alias == eql?
      private :eql?
    end
  end
end
