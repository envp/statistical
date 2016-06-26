require 'statistical/distribution/gumbel'

module Statistical
  module Rng
    # Companion RNG class for the continuous Gumbel distribution. Requires a
    #   distrbution object of the corresponding distribution
    #
    # @author Vaibhav Yenamandra
    #
    # @attr_reader [Float] location The location parameter of the Gumbel
    #   distribution
    # @attr_reader [Float] scale The scale parameter of the Gumbel distribution
    # @attr_reader [Float] generator The underlying uniform variate source used
    #   to power `Gumbel#rand`
    class Gumbel
      attr_reader :generator, :location, :scale

      def initialize(dobj = nil, seed = Random.new_seed)
        unless dobj.nil? || dobj.is_a?(Statistical::Distribution::Gumbel)
          raise TypeError,
                "Expected Distribution object or nil, found #{dobj.class}"
        end
        dobj = Statistical::Distribution::Gumbel.new if dobj.nil?
        @generator = Random.new(seed)
        @location = dobj.location
        @scale = dobj.scale
        @sdist = dobj
      end

      # Return the next random number from the sequence
      #
      # @return [Float] next random number in the sequence
      def rand
        @sdist.quantile(@generator.rand)
      end

      # Compare against another rng to see if they are the same
      #
      # @return true if and only if, source distributions are the same and the
      #   prng has the same initial state
      def eql?(other)
        return other.is_a?(self.class) &&
               @generator == other.generator &&
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
