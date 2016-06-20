require 'statistical/helpers'

module Statistical
  module Distribution
    # This class models the Frechet (or inverse Weibull) distribution which is
    #   a type-2 extreme value distribution.
    #
    # @author Vaibhav Yenamandra
    # @attr_reader [Numeric] alpha Mandatory shape parameter of the distribution
    # @attr_reader [Numeric] location Optional location parameter
    # @attr_reader [Numeric] scale Optional scale parameter
    # @attr_reader [Numeric] support Support / domain of the distribution's
    #   PDF / CDF
    class Frechet
      attr_reader :alpha, :location, :scale, :support

      # Returns a new `Statistical::Distribution::Frechet` instance
      #
      # @param [Numeric] alpha Mandatory shape parameter of the distribution
      # @param [Numeric] location Optional location parameter
      # @param [Numeric] scale Optional scale parameter
      # @return [Frechet] `Statistical::Distribution::Frechet` instance
      def initialize(alpha=nil, location=0, scale=1)
        raise ArgumentError if alpha.nil?

        @alpha = alpha.to_f
        @location = location.to_f
        @scale = scale.to_f
        @support = Domain[@location, Float::INFINITY, :full_open]
      end

      # Returns value of probability density function at a point.
      #
      # @param [Numeric] x A real valued point
      # @return [Float] Probability density function evaluated at `x`
      def pdf(x)
        xs = (x - @location) / @scale

        # Not following the usual array lookup idiom here since the PDF
        # expression is ill-defined (Complex) for x < location. Lazily evaluated
        # expressions would help retain the array lookup idiom, but that's for
        # later
        if (@support <=> x).zero?
          return (@alpha / @scale) * xs**(-1-@alpha) * Math.exp(-(xs**-@alpha))
        else
          return 0
        end
      end

      # Returns value of cumulative density function upto the specified point
      #
      # @param [Numeric] x A real valued point
      # @return [Float] Cumulative density function evaluated for F(u <= x)
      def cdf(x)
        xs = (x - @location) / @scale

        case @support <=> x
        when 0
          return Math.exp(-(xs**(-@alpha)))
        when 1
          return 1
        when -1
          return 0
        end
      end

      # Returns value of inverse CDF for a given probability
      #
      # @see #p_value
      #
      # @param [Numeric] p a value within [0, 1]
      # @return [Float] Inverse CDF for valid p
      # @raise [RangeError] if p > 1 or p < 0
      def quantile(p)
        raise RangeError, "`p` must be in [0, 1], found: #{p}" if p < 0 || p > 1
        return @location + @scale * ((-Math.log(p))**(-1 / @alpha))
      end

      # Returns the mean value for the calling instance. Calculated mean, and
      #   not inferred from simulations
      #
      # @return Mean of the distribution
      def mean
        return [
          Float::INFINITY,
          @location + @scale * Math.gamma(1 - 1 / @alpha),
          Float::INFINITY
        ][@alpha <=> 1.0]
      end

      # Returns the expected value of variance for the calling instance.
      #
      # @return Variance of the distribution
      def variance
        return [
          Float::INFINITY,
          @scale * @scale * (
            Math.gamma(1 - 2 / @alpha) -
            Math.gamma(1 - 1 / @alpha)**2
          ),
          Float::INFINITY
        ][@alpha <=> 2.0]
      end

      # Compares two distribution instances and returns a boolean outcome
      #   Available publicly as #==
      #
      # @private
      #
      # @return [Boolean] true if-and-only-if two instances are of the same
      #   class and have the same parameters.
      def eql?(other)
        return other.is_a?(self.class) &&
               @alpha == other.alpha &&
               @location == other.location &&
               @scale == other.scale
      end

      alias :== :eql?
      alias :p_value :quantile

      private :eql?
    end
  end
end
