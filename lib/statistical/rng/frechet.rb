require 'statistical/distribution/frechet'

module Statistical
  # Companion RNG class for the continuous uniform distribution. Requires a
  #   distrbution object of the corresponding distribution
  #
  # @author Vaibhav Yenamandra
  #
  # @attr_reader [Numeric] lower The lower bound of the uniform distribution.
  # @attr_reader [Numeric] upper The upper bound of the uniform distribution.
  module Rng
    class Frechet
      attr_reader :generator, :alpha, :location, :scale

      def initialize(dobj = nil, seed = Random.new_seed)
        if dobj.nil?
          raise ArgumentError, "Need a alpha-parametrized Frechet object!"
        elsif !dobj.is_a?(Statistical::Distribution::Frechet)
          raise TypeError, "Expected Frechet Distribution found #{dobj.class}"
        end

        @generator = Random.new(seed)
        @alpha = dobj.alpha
        @location = dobj.location
        @scale = dobj.scale
        @sdist = dobj
      end

      # Return the next random number from the sequence
      #
      # @return [Float] next random number in the sequence
      def rand
        return @sdist.quantile(@generator.rand)
      end

      # Compare against another rng to see if they are the same
      #
      # @return true if and only if, source distributions are the same and the
      #   prng has the same initial state
      def eql?(other)
        return other.is_a?(self.class) &&
               @generator == other.generator &&
               @alpha == other.alpha &&
               @location == other.location &&
               @scale == other.scale
      end

      # Return the type of the source distribution
      #
      # @return source distribution's type
      def type
        @sdist.class
      end

      alias_method :==, :eql?
      private :eql?
    end
  end
end
