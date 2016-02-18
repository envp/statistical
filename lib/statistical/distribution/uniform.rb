require 'statistical/exceptions'

module Statistical
  module Distribution
    class Uniform
      attr_reader :lower, :upper

      def initialize(lower = 0.0, upper = 1.0)
        @lower = [lower, upper].min
        @upper = [lower, upper].max
      end

      def pdf(x)
        return 0.0 if x < @lower || x > @upper
        return 1.0 / (@upper - @lower)
      end
      
      def cdf(x)
        return 0.0 if x < @lower
        return 1.0 if x > @upper
        return (x - @lower) / (@upper - @lower)
      end
      
      def quantile(q)
        raise RangeError, "`q` must be in [0, 1]" if q < 0 || q > 1
        return @lower + q * (@upper - @lower)
      end
      
      def mean
        return 0.5 * (@upper - @lower)
      end
      
      def variance
        return ((@upper - @lower) ** 2) / 12.0
      end
      
      def eql?(other)
        return false unless other.is_a?(Statistical::Distribution::Uniform)
        return false unless @lower == other.lower && @upper == other.upper
        true
      end

      alias == eql?
      alias p_value quantile
    end
  end
end
