require 'statistical/exceptions'

module Statistical
  module Distribution
    # Abstraction of common statistical properties of the exponential
    #   distribution
    #
    # @author Vaibhav Yenamandra
    # @attr_reader [Numeric] rate Rate parameter controlling the
    #   exponential distribution. Same as `λ` in the canonical version
    class Exponential
      attr_reader :rate

      # Returns a new `Statistical::Distribution::Uniform` instance
      # 
      # @param [Numeric] rate Rate parameter of the exponential distribution.
      #   Same as `λ` in the canonical version
      # @return `Statistical::Distribution::Exponential` instance      
      def initialize(rate = 1)
        @rate = rate
        self
      end
      
      # Returns value of probability density function at a point.
      # 
      # @param [Numeric] x A real valued point
      # @return [Float] Probility density function evaluated at x
      def pdf(x)
        return 0 if x < 0
        return @rate * Math.exp(-rate * x)
      end

      # Returns value of cumulative density function at a point.
      # 
      # @param [Numeric] x A real valued point
      # @return [Float] Probability mass function evaluated at x
      def cdf(x)
        return 0 if x <= 0
        return 1 - Math.exp(-@rate * x)
      end

      # Returns value of inverse CDF for a given probability
      #
      # @see #p_value
      # 
      # @param [Float] p a value within [0, 1]
      # @return Inverse CDF for valid p
      # @raises [RangeError] if p > 1 or p < 0
      def quantile(p)
        raise RangeError, "`p` must be in [0, 1], found: #{p}" if p < 0 || p > 1
        return Math.log(1 - p) / (-@rate)
      end

      # Returns the mean value for the calling instance. Calculated mean, and
      #   not inferred from simulations
      # 
      # @param [Numeric] p a value within [0, 1]
      # @return Mean of the distribution
      def mean
        return 1.0 / @rate
      end

      # Returns the expected value of variance for the calling instance.
      # 
      # @param [Numeric] p a value within [0, 1]
      # @return Variance of the distribution
      def variance
        return (1.0 / @rate) ** 2
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
        return other.is_a?(self.class) && @rate == other.rate
      end

      alias_method :==, :eql?
      alias_method :p_value, :quantile
      
      private :eql?
    end
  end
end
