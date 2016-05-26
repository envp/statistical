require 'statistical/exceptions'

module Statistical
  module Distribution
    # Say something useful about this class.
    #
    # @note Any caveats you want to talk about go here...
    #
    # @author Vaibhav Yenamandra
    # @attr_reader [Numeric] scale Scale parameter of the Laplace distribution.
    # @attr_reader [Numeric] location Location parameter to determine where the 
    #   distribution is centered / where the mean lies at
    class Laplace
      attr_reader :scale, :location

      # Returns a new instance of the Laplace distribution; also known as
      #   the two-sided exponential distribution
      # 
      # @param [Numeric] scale Scale parameter of the Laplace distribution.
      # @param [Numeric] location Location parameter to determine where the 
      #   distribution is centered / where the mean lies at
      # @return `Statistical::Distribution::Laplace` instance      
      def initialize(scale = 1, location = 0)
        @scale = scale
        @location = location
        self
      end
      
      # Returns value of probability density function at a point.
      # 
      # @param [Numeric] x A real valued point
      # @return [Float] Probility density function evaluated at x
      def pdf(x)
        x_ = Math.abs((x - @location).fdiv @scale)
        return Math.exp(- x_).fdiv(2 * @scale)
      end

      # Returns value of cumulative density function at a point.
      # 
      # @param [Numeric] x A real valued point
      # @return [Float] Cumulative density function evaluated at x
      def cdf(x)
        return 0.5 if x == @location
        if x < @location
          return 0.5 * Math.exp( (x - @location).fdiv @scale )
        else
          return 1.0 - 0.5 * Math.exp( (@location - x).fdiv @scale )
        end
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
        return @location if p == 0.5
        
        if p < 0.5
          return @scale * log(2 * p) + @location
        else
          return @location - @scale * log(1.0 - p)
        end
      end

      # Returns the expected mean value for the calling instance. 
      #
      # @return Mean of the distribution
      def mean
        return @location
      end

      # Returns the expected value of variance for the calling instance.
      #
      # @return Variance of the distribution
      def variance
        return 2 * @scale * @scale
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
        return false unless other.is_a?(self.class) &&
          other.scale == @scale &&
          other.location == @location
        return true
      end

      alias_method :==, :eql?
      alias_method :p_value, :quantile
      
      private :eql?
    end
  end
end
