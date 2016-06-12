require 'statistical/exceptions'
require 'statistical/distribution/weibull'

module Statistical
  # Companion RNG class for the continuous uniform distribution. Requires a
  #   distrbution object of the corresponding distribution
  #
  # @author Vaibhav Yenamandra
  #
  # @attr_reader [Numeric] scale The scale parameter of the Weibull distribution
  # @attr_reader [Numeric] shape The shape parameter of the Weibull distribution
  module Rng
    class Weibull
      attr_reader :generator, :scale, :shape

      def initialize(dobj = nil, seed = Random.new_seed)
        unless dobj.nil? || dobj.is_a?(Statistical::Distribution::Weibull)
          raise TypeError,
                "Expected Distribution object or nil, found #{dobj.class}"
        end
        dobj = Statistical::Distribution::Weibull.new if dobj.nil?
        @generator = Rng::Uniform.new(Distribution::Uniform.new, seed)
        @scale = dobj.scale
        @shape = dobj.shape
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
               @generator == other.generator &&
               @scale == other.scale &&
               @shape == other.shape
      end

      # Return the type of the source distribution
      #
      # @return source distribution's class
      def type
        @sdist.class
      end

      alias_method :==, :eql?
      private :eql?
    end
  end
end
