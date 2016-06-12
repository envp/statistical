require 'statistical/exceptions'

module Statistical
  module Distribution
    # Say something useful about this class.
    #
    # @note Any caveats you want to talk about go here...
    #
    # @author Vaibhav Yenamandra
    # @attr_reader [Float] scale The distribution's scale parameter
    # @attr_reader [Float] shape The distribution's shape parameter
    class Weibull
      attr_reader :scale, :shape

      # Returns a new `Statistical::Distribution::Weibull` instance
      #
      # @param [Numeric] scale The distribution's scale parameter
      # @param [Numeric] shape The distribution's shape parameter
      # @return `Statistical::Distribution::Weibull` instance
      def initialize(scale = 1, shape = 1)
        @scale = scale.to_f
        @shape = shape.to_f
      end

      # Returns value of probability density function at a point. Calculated
      #   using some technique that you might want to name
      #
      # @param [Numeric] x A real valued point
      # @return
      def pdf(x)
        return 0 if x <= 0

        return (@shape / @scale) *
               ((x / @scale)**(@shape - 1)) *
               Math.exp(-((x / @scale)**@shape))
      end

      # Returns value of cumulative density function at a point. Calculated
      #   using some technique that you might want to name
      #
      # @param [Numeric] x A real valued point
      # @return
      def cdf(x)
        return 0 if x <= 0
        xa = (x / @scale)**@shape
        return 1 - Math.exp(-xa)
      end

      # Returns value of inverse CDF for a given probability
      #
      # @see #p_value
      #
      # @param [Numeric] p a value within [0, 1]
      # @return Inverse CDF for valid p
      # @raises [RangeError] if p > 1 or p < 0
      def quantile(p)
        raise RangeError, "`p` must be in [0, 1], found: #{p}" if p < 0 || p > 1
        return @scale * ((-Math.log(1 - p))**(1 / @shape))
      end

      # Returns the expected value of mean for the calling instance.
      #
      # @return Mean of the distribution
      def mean
        return @scale * Math.gamma(1 + 1 / @shape)
      end

      # Returns the expected value of variance for the calling instance.
      #
      # @return Variance of the distribution
      def variance
        m = mean
        (@scale * @scale) * Math.gamma(1 + 2 / @shape) - (m * m)
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
               other.shape == @shape &&
               other.scale == @scale
      end

      alias :== :eql?
      alias :p_value :quantile

      private :eql?
    end
  end
end
