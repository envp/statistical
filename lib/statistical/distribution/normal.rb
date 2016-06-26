require 'statistical/helpers'

module Statistical
  module Distribution
    # Class representing the normal distribution with mu=location and
    #   sigma=scale
    #
    # @author Vaibhav Yenamandra
    #
    # @attr_reader [Numeric] location parameter mu of the normal distribution
    # @attr_reader [Numeric] scale standard deviation of the normal distribution
    class Normal
      include Statistical::Constants

      attr_reader :location, :scale, :support

      # Returns a new `Statistical::Distribution::Normal` instance
      #
      # @param [Numeric] location parameter mu of the normal distribution
      # @param [Numeric] scale standard deviation of the normal distribution
      # @return `Statistical::Distribution::Normal` instance
      def initialize(location=0, scale=1)
        @location = location.to_f
        @scale = scale.to_f
        @support = Domain[-Float::INFINITY, Float::INFINITY, :full_open]
      end

      # Returns value of probability density function at a point.
      #
      # @param [Numeric] x A real valued point
      # @return Probability density function evaluated at `x`
      def pdf(x)
        z = (x - @location) / @scale
        return Math.exp(-(z / SQRT_2)**2).fdiv(SQRT_2PI * scale)
      end

      # Returns value of cumulative density function at a point.
      #
      # @param [Numeric] x A real valued point
      # @return Cumulative density function evaluated for F(u <= x)
      def cdf(x)
        z = (x - @location) / @scale
        return 0.5 * (1 + Math.erf(z / SQRT_2))
      end

      # Returns value of inverse CDF for a given probability.
      #
      # @note For small to medium arguments it first computes an initial
      #   polynomial approximation to be used as the initial guess for a
      #   Newton-Raphson step. If the arguments are very large Wichura's
      #   algorithm is used to invert Phi(x).
      #   The accuracy of this method is limited to a z-score magnitude of 5
      #
      # @note References:
      #   * Beasley, J. D. and S. G. Springer (1977). Algorithm AS 111:
      #     The percentage points of the normal distribution,
      #     Applied Statistics, 26, 118-121.
      #     (http://www.jstor.org/stable/2346889)
      #   * Wichura, M.J. (1988). Algorithm AS 241: The Percentage Points
      #     of the Normal Distribution. Applied Statistics, 37, 477-484
      #     (http://www.jstor.org/stable/2347330)
      #
      # This implementation has been derived from the Q-function source of
      #   R's normal distribution.
      #
      # @see #p_value
      #
      # @param [Numeric] p a value within [0, 1]
      # @return Inverse CDF for valid p (Along with the appropriate inifinities)
      # @raise [RangeError] if p > 1 or p < 0
      def quantile(p)
        raise RangeError, "`p` must be in [0, 1], found: #{p}" if p < 0 || p > 1
        return -Float::INFINITY if p == 0
        return  Float::INFINITY if p == 1
        return  @location if p == 0.5

        # Setup all the necessary vars
        q, r, z = p - 0.5, 0, 0

        # 0.075 <= p <= 0.9375
        poly_central = {
          num: [
            2509.0809287301226727, 33430.575583588128105,
            67265.770927008700853, 45921.953931549871457,
            13731.693765509461125, 1971.5909503065514427,
            133.14166789178437745, 3.387132872796366608
          ],
          den: [
            5226.495278852854561, 28729.085735721942674,
            39307.89580009271061, 21213.794301586595867,
            5394.1960214247511077, 687.1870074920579083,
            42.313330701600911252, 1
          ]
        }.freeze

        # 1.6 < sqrt(-log(min(p, 1 - p))) < 5
        poly_tail_a  = {
          num: [
            7.7454501427834140764e-4, 0.0227238449892691845833,
            0.24178072517745061177,   1.27045825245236838258,
            3.64784832476320460504,   5.7694972214606914055,
            4.6303378461565452959,    1.42343711074968357734
          ],
          den: [
            1.05075007164441684324e-9,  5.475938084995344946e-4,
            0.0151986665636164571966,   0.14810397642748007459,
            0.68976733498510000455,     1.6763848301838038494,
            2.05319162663775882187,     1
          ]
        }.freeze

        # sqrt(-log(min(p, 1 - p))) > 5
        poly_tail_b = {
          num: [
            7.7454501427834140764e-4, 0.0227238449892691845833,
            0.24178072517745061177,   1.27045825245236838258,
            3.64784832476320460504,   5.7694972214606914055,
            4.6303378461565452959,    1.42343711074968357734
          ],
          den: [
            1.05075007164441684324e-9,  5.475938084995344946e-4,
            0.0151986665636164571966,   0.14810397642748007459,
            0.68976733498510000455,     1.6763848301838038494,
            2.05319162663775882187,     1
          ]
        }.freeze

        if q.abs <= 0.425
          # Central region, which can be approximated polynomially
          # Here: 0.075 <= p <= 0.9375
          r = 0.180625 - q*q
          z = q * poly_central[:num].inject(0) {|a, pn| a = a * r + pn}.fdiv(
                  poly_central[:den].inject(0) {|a, pn| a = a * r + pn}
          )
        else
          # Tail region of the curve. here either min(p, 1 - p) < 0.075 holds
          r = (-Math.log([p, 1 - p].min))**0.5
          if r <= 5
            r = r - 1.6
            z = poly_tail_a[:num].inject(0) {|a, pn| a = a * r + pn}.fdiv(
                poly_tail_a[:den].inject(0) {|a, pn| a = a * r + pn}
            )
          else
            #  5 < r < 27 is where these minimax approximations work best
            r = r - 5
            z = poly_tail_b[:num].inject(0) {|a, pn| a = a * r + pn}.fdiv(
                poly_tail_b[:den].inject(0) {|a, pn| a = a * r + pn}
            )
          end
        end

        return @location + @scale * z * (q <=> 0)
      end

      # Returns the mean value for the calling instance.
      #
      # @return [Float] Mean of the distribution
      def mean
        return @location
      end

      # Returns the expected value of variance for the calling instance.
      #
      # @return [Float] Variance of the distribution
      def variance
        return @scale**2
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
        return  other.is_a?(self.class) &&
                other.location == @location &&
                other.scale == @scale
      end

      alias :== :eql?
      alias :p_value :quantile

      private :eql?
    end
  end
end
