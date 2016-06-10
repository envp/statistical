require 'statistical/exceptions'
require 'statistical/distribution/exponential'
require 'statistical/distribution/uniform'
require 'statistical/rng/uniform'

module Statistical
  module Rng
    # Companion RNG class for the exponential distribution. Requires a
    #   distrbution object of the corresponding distribution
    #
    # @author Vaibhav Yenamandra
    #
    # @attr_reader [Numeric] rate Rate parameter of the exponential distribution
    # @attr_reader [Numeric] upper The upper bound of the uniform distribution
    class Exponential
      attr_reader :rate, :generator

      def initialize(dobj = nil, seed = Random.new_seed)
        unless dobj.nil? || dobj.is_a?(Statistical::Distribution::Exponential)
          raise TypeError,
                "Expected Distribution object or nil, found #{dobj.class}"
        end
        dobj = Statistical::Distribution::Exponential.new if dobj.nil?
        @generator = Rng::Uniform.new(Distribution::Uniform.new, seed)
        @rate = dobj.rate
        @sdist = dobj
      end

      # Return the next random number from the sequence
      #
      # @return [Numeric] next random number in the sequence
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
               @rate = other.rate
      end

      # Return the type of the source distribution
      #
      # @return source distribution's type
      def type
        @sdist.class
      end

      alias :== :eql?
      private :eql?
    end
  end
end
