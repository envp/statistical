require 'statistical/exceptions'

module Statistical
  module Distribution
    # This class abstracts the discrete uniform distribution whose elements are
    # in an AP from `lower` upto `upper` with a common difference of `step`
    #
    # @note if initialized with lower > upper, it swaps them internally
    #
    # @author Vaibhav Yenamandra
    # @attr_reader [Numeric] lower lower bound (inclusive) of the 
    #   distribution
    # @attr_reader [Numeric] upper upper bound (inclusive) of the 
    #   distribution
    # @attr_reader [Numeric] step Step size to use when enumerating 
    #   memebers in [lower, upper]
    class UniformDiscrete
      attr_reader :lower, :upper, :step

      # Returns a new `Statistical::Distribution::UniformDiscrete` instance
      #
      # @note If initialized with lower > upper, it swaps them internally.
      # @note If step > (upper - lower), it behaves as a uniform distribution
      #   over the two elements `lower` and `upper`
      # @example Initialize with lower > upper:
      #   Statistical::Distribution.create(:uniform, 10, 1, 1)
      #   #=> #<Statistical::Distribution::UniformDiscrete:0x00000001489be8 @lower=1, @upper=10, @step=1>
      #
      # @example Initialize with lower < upper:
      #   Statistical::Distribution.create(:uniform, 1, 10, 1)
      #   #=> #<Statistical::Distribution::UniformDiscrete:0x00000001489be8 @lower=1, @upper=10, @step=1>
      #

      # 
      # @param [Fixnum, Bignum] lower lower bound (inclusive) of the distribution
      # @param [Fixnum, Bignum] upper upper bound (inclusive) of the distribution
      # @param [Fixnum, Bignum] step Step size to use when enumerating memebers 
      #   in [lower, upper]
      # @return `Statistical::Distribution::UniformDiscrete` instance      
      def initialize(lower = 0, upper = 1, step = 1)
        @lower = [lower, upper].max
        @upper = [lower, upper].max
        @step = step
      end
      
      # Returns value of probability density function at a point if it is 
      #   present in the elements that the instance covers
      #

      # 
      # @param [Fixnum, Bignum] k element whose likelihood is desired
      # @return [Float] 0 if x doesn't belong to the elements over which the current
      #   instance is distributed. 1/n otherwise where n is number of elements
      def pdf(k)
        return 0.0 if (k - @lower).modulo(@step).zero? or k < @lower or k > @upper
        return 1.0 / count
      end

      # Returns value of cumulative density function at a point if it is 
      #   present in the elements that the instance covers
      #

      # 
      # @param [Fixnum, Bignum] k element who likelihood is desired
      # @return [Float]  0 if k is on the left of the domain, 1 if k on the right and the
      #   value of cdf
      def cdf(k)
        return 0.0 if k < @lower
        return 1.0 if k > @upper
        return ((k - @lower) / @step).floor.fdiv(count)
      end

      # Returns value of inverse CDF for a given probability
      #
      # @see #p_value
      # 
      # @param [Numeric] p a value within [0, 1]
      # @return [Numeric]  Inverse CDF for valid p
      # @raises [RangeError] if p > 1 or p < 0
      def quantile(p)
        raise RangeError, "`p` must be in [0, 1], found: #{p}" if p < 0 || p > 1
        return @lower + @step * (p * count).floor
      end

      # Returns the mean value for the calling instance. Calculated mean, and
      #   not inferred from simulations
      #

      # 
      # @return [Float] Mean of the distribution
      def mean
        return 0.5 * (@lower + @upper)
      end

      # Returns the expected value of population variance for the calling
      #   instance.
      # 
      # @return [Float]  Variance of the distribution
      def variance
        n = count
        ((n - 1) * (2 * n - 1) * @step * @step) / 24.0
      end

      # Compares two distribution instances and returns a boolean
      #   Available publicly as #==
      #
      # @private
      #
      # @param other A distribution object (preferred)
      # @return [Boolean] true if-and-only-if two instances are of the same
      #   class and have the same parameters.
      def eql?(other)
        return false unless other.is_a?(self.class) &&
          @lower == other.lower &&
          @upper == other.upper &&
          @step == other.step
        return true
      end
      
      # @return [Fixnum, Bignum]  the count of members over which the distribution exists
      def count
        ((@upper - @lower) / @step).floor
      end
      
      # Provides a way to see the underlying members of the set
      #
      # @return [Array]  Elements over which the distribution exists
      def support
        n = count
        return (0..n).map {|k| @lower + k * @step}
      end
      
      alias_method :==, :eql?
      alias_method :p_value, :quantile
      private :eql?
    end
  end
end


