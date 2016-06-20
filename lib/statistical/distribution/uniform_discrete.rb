require 'statistical/core_extensions'

module Statistical
  # Module to collect all abstractions of distributions
  module Distribution
    # This class abstracts the discrete uniform distribution over a given set
    #   of elements
    #
    # @author Vaibhav Yenamandra
    # @attr_reader [Array, Numeric] support The support set of valid values a
    # random variate from the distribution can take. Must have at least 1 value
    class UniformDiscrete
      using Statistical::ArrayExtensions

      attr_reader :count, :support, :lower, :upper
      # Returns a model for the discrete uniform distribution on all elements
      # present in the given set of elemets `elems`
      #
      # @note The constructor sorts the array of elements given to it, as this
      #   is a key assumption of the discrete uniform distribution. This set
      #   must also be homogenous
      #
      # @param [Array] elems The elements over which the distribution exists
      #   in [lower, upper]
      # @raise [RangeError] if elems isn't one of Array, Range, Fixnum or
      #   Bignum
      def initialize(elems)
        case elems
        when Fixnum, Bignum
          @support = [elems]
        when Array
          @support = elems.sort
        when Range
          @support = elems.to_a
        else
          raise ArgumentError,
                "Expected Fixnum, Bignum, Array or Range, found #{elems.class}"
        end
        @count = @support.length
        @lower = @support[0]
        @upper = @support[-1]
        self
      end

      # Returns value of probability density function at a point on the real
      #   line
      #
      # @param [Fixnum, Bignum] k Point at which pdf is desired
      # @return [Float] 0 if k doesn't belong to the elements over which the
      #   current instance is distributed. 1/n otherwise where n is number
      #   of elements
      def pdf(k)
        return 1.0 / @count if @support.include?(k)
        return 0.0
      end

      # Returns value of cumulative density function at a point on the real line
      # Uses a binary search on the support array internally.
      #
      # @note This suffers from some floating point comparison issues. Errors
      #   start appearing when dealing with precision > 1E-18
      #
      # @param [Fixnum, Bignum] k Point at which cdf value is desired
      # @return [Float]  0 if k is on the left of the support,
      #   1 if k on the right support and the
      #   evaluates CDF for any other legal value
      def cdf(k)
        return 0.0 if k < @lower
        return 1.0 if k >= @upper

        # Ruby has a Array#bsearch_index already but it supports find-min mode
        # What we need is a find-max mode. This can be achieved by reversing
        # and then searching, but reverse is O(N) so it defeats the purpose
        low = 0
        high = @count - 1
        while low < high
          mid = (low + high) / 2
          if @support[mid] <= k
            low = mid + 1
          else
            high = mid
          end
        end
        # This should be true for all i > low
        return low.fdiv(@count)
      end

      # Returns value of inverse CDF for a given probability.
      #
      # @see #p_value
      #
      # @param [Numeric] p a value within [0, 1]
      # @return [Numeric]  Returns inverse CDF for valid p
      # @raise [RangeError] if p > 1 or p < 0
      def quantile(p)
        raise RangeError, "`p` must be in [0, 1], found: #{p}" if p < 0 || p > 1
        return @lower if p.zero?
        return @upper if (p - 1).zero?
        return @support[(p * count).ceil - 1]
      end

      # Returns the mean value for the calling instance. Calculated mean, and
      #   not inferred from simulations
      #
      # @return [Float] Mean of the distribution
      def mean
        return @support.mean
      end

      # Returns the expected value of population variance for the calling
      #   instance.
      #
      # @return [Float]  Variance of the distribution
      def variance
        return @support.pvariance
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
        return other.is_a?(self.class) &&
               @support == other.support
      end

      alias :== :eql?
      alias :p_value :quantile

      private :eql?
    end
  end
end
