require 'statistical/helpers'

module Statistical
  module Distribution
    # An abstraction of the common statistical properties of the uniform
    # distribution. Provides a PDF, CDF, Inverse-CDF, mean, variance
    #
    # @note If initialized with lower and upper parameters in reverse order, it
    #   swaps them. Eg. initializing with lower = 10 and upper = 2 is the same
    #   as lower = 2 and upper = 10, due to the swap during call to new(,)
    #
    # @author Vaibhav Yenamandra
    #
    # @attr_reader [Numeric] lower The lower bound of the uniform distribution.
    #   Defaults to 0.0.
    # @attr_reader [Numeric] upper The upper bound of the uniform distrbution.
    #   Defaults to 1.0.
    class Uniform
      attr_reader :lower, :upper, :support

      # Returns a new `Statistical::Distribution::Uniform` instance
      #
      # @note if given lower > upper, it swaps them internally
      #
      # @param [Numeric] start lower bound of the distribution.
      # @param [Numeric] finish upper bound of the distribution.
      # @return `Statistical::Distribution::Uniform` instance
      def initialize(start = 0.0, finish = 1.0)
        @lower = [start, finish].min
        @upper = [start, finish].max
        @support = Domain[@lower, @upper, :closed]
      end

      # Returns value of probability density function at a point
      #
      # @param [Numeric] x A real valued point
      # @return [Float] 1 if x is within [lower, upper], 0 otherwise
      def pdf(x)
        return [1.0 / (@upper - @lower),  0.0, 0.0][@support <=> x]
      end

      # Returns value of cumulative density function at a point
      #
      # @param [Numeric] x A real valued point
      # @return [Float] 1 if x is within [lower, upper], 0 otherwise
      def cdf(x)
        return [(x - @lower).fdiv(@upper - @lower), 1.0, 0.0][@support <=> x]
      end

      # Returns value of inverse CDF for a given probability
      #
      # @see #p_value
      #
      # @param [Numeric] p a value within [0, 1]
      # @return [Numeric] Inverse CDF for valid p
      # @raise [RangeError] if p > 1 or p < 0
      def quantile(p)
        raise RangeError, "`p` must be in [0, 1], found: #{p}" if p < 0 || p > 1
        return @lower + p * (@upper - @lower)
      end

      # Returns the expected value of mean value for the calling instance.
      #
      # @author Vaibhav Yenamandra
      #
      # @return [Float] Mean of the distribution
      def mean
        return 0.5 * (@upper + @lower)
      end

      # Returns the expected value of variance for the calling instance.
      #
      # @return [Float] Variance of the distribution
      def variance
        return ((@upper - @lower)**2) / 12.0
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
               @lower == other.lower &&
               @upper == other.upper
      end

      alias :== :eql?
      alias :p_value :quantile

      private :eql?
    end
  end
end
