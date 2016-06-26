require 'statistical/helpers'

module Statistical
  module Distribution
    # Distribution class for Extreme value type-3 or Gumbel distribution
    #
    # @author Vaibhav Yenamandra
    #
    # @attr_reader location [Float] The distributions location parameter
    # @attr_reader scale [Float] The dstribution's scale parameter
    # @attr_reader support [Float] The region of the real line where this
    #   distribution is defined to exist
    class Gumbel
      include Statistical::Constants
      
      attr_reader :location, :scale, :support

      # Returns a new `Statistical::Distribution::Gumbel` instance
      #
      # @param [Float] location location parameter of the distribution
      # @param [Float] The dstribution's scale parameter
      # @return `Statistical::Distribution::Gumbel` instance
      def initialize(location = 0, scale = 1)
        @location = location.to_f
        @scale = scale.to_f
        @support = Domain[-Float::INFINITY, Float::INFINITY, :full_open]
      end

      # Returns value of probability density function at a point.
      #
      # @param [Numeric] x A real valued point
      # @return Probability density function evaluated at `x`
      def pdf(x)
        xa = (x - @location) / @scale
        return [
          Math.exp(-xa - Math.exp(-xa)) / @scale,
          0.0,
          0.0
        ][@support <=> x]
      end

      # Returns value of cumulative density function upto a point.
      #
      # @param [Numeric] x A real valued point
      # @return Cumulative density function evaluated for F(u <= x)
      def cdf(x)
        xa = (x - @location) / @scale
        return [
          Math.exp(-Math.exp(-xa)),
          1.0,
          0.0
        ][@support <=> x]
      end

      # Returns value of inverse CDF for a given probability
      #
      # @see #p_value
      #
      # @param [Numeric] p a value within [0, 1]
      # @return Inverse CDF for valid p
      # @raise [RangeError] if p > 1 or p < 0
      def quantile(p)
        raise RangeError, "`p` must be in [0, 1], found: #{p}" if p < 0 || p > 1
        return @location - @scale * Math.log(-Math.log(p))
      end

      # Returns the expected value of the mean for the calling instance.
      #
      # @return Mean of the distribution
      def mean
        return @location + @scale * EULER_GAMMA
      end

      # Returns the expected value of variance for the calling instance.
      #
      # @return Variance of the distribution
      def variance
        return ((Math::PI * @scale)**2) / 6
      end

      # Compares two distribution instances and returns a boolean outcome
      #   Available publicly as #==
      #
      # @private
      #
      # @param other A distribution object (preferred)
      # @return [Boolean] true if-and-only-if two instances are of the same
      #   class and have the same parameters.
      def eql?(other)
        return other.is_a?(self.class) &&
               @location == other.location &&
               @scale == other.scale
      end

      alias :== :eql?
      alias :p_value :quantile

      private :eql?
    end
  end
end
