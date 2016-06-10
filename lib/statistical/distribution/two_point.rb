require 'statistical/exceptions'

module Statistical
  module Distribution
    # Two-Point distribution implementation that uses generic labels for states
    # that it's random variables can take. The assumptions made would be that
    # the states are comparable and failure < success in whatever scheme of
    # comparison that the state objects implement. This defaults to behaving as
    # the bernoulli distribution
    #
    # @note The states used to represent success & failure must be Numeric.
    #   Using it on generic state lables can cause strange outcomes!
    #
    # @note state_failure < state_sucesss, for the sake of sanity.
    #
    # @author Vaibhav Yenamandra
    # @attr_reader [Float] p probability of the success state
    # @attr_reader [Float] q probability of the failure state
    # @attr_reader [Hash] states Hash with keys :failure, :success to hold
    #   their respective state objects(defaults to 0, 1 respectively)
    class TwoPoint
      # This is probably the best but the least descriptive variable name
      attr_reader :p, :q, :states

      # Returns a new instance of the TwoPoint distribution
      #
      # @note The states used to represent success & failure must be Numeric.
      #   Using it on generic state lables can cause strange outcomes!
      #
      # @note state_failure < state_sucesss, required to have a sane CDF.
      #
      # @param [Float] prob_success The probability of success
      # @param [Numeric] state_success An object to describe the 1-state of
      #   success
      # @param [Numeric] state_failure An object to describe the 0-state of
      #   failure
      def initialize(prob_success = 0.5, state_failure = 0, state_success = 1)
        if state_failure == state_success
          raise ArgumentError,
                'Success & failure must be two distinct states'
        end

        if state_failure > state_success
          raise ArgumentError,
                'Failure state must be smaller that the success state!'
        end

        unless (state_failure + state_success).is_a?(Numeric)
          raise ArgumentError,
                "States must be Numeric! Found #{state_failure.class} and #{state_success.class}"
        end

        if prob_success > 1 || prob_success < 0
          raise ArgumentError,
                "Probabilty of success must be within [0, 1]. Found #{prob_success}"
        end

        @p = prob_success
        @q = 1 - prob_success
        @states = {
          failure: state_failure,
          success: state_success
        }
        self
      end

      # Returns value of probability density function at a given state of the
      # random variate X. Essentially: "what's P(X=x)?"
      #
      # @param x [Numeric] The state the the random variable takes. Can be 0, 1
      # @return [Float] * p if state (x) is 1.
      # @raise [ArgumentError] if x is not of the states this instance was
      #   initialized with
      def pdf(x)
        return @p if @states[:success] == x
        return @q if @states[:failure] == x
        return 0
      end

      # Returns value of cumulative density function at a point. Calculated
      #   using some technique that you might want to name
      #
      # @param x [Numeric] The state the the random variable takes. Can be 0, 1
      # @return [Float] The cumulative probability over all of the random
      #   variates states.
      def cdf(x)
        return 0 if x < @states[:failure]
        return @q if x.between?(@states[:failure], @states[:success])
        return 1 if x >= @states[:success]
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
        return @states[:failure] if p <= @q
        return @states[:success] if p > @q
      end

      # Returns the expected mean value for the calling instance.
      #
      # @return Mean of the distribution
      def mean
        return @p * @states[:success] + @q * @states[:failure]
      end

      # Returns the expected value of variance for the calling instance.
      #
      # @return Variance of the distribution
      def variance
        return @p * (@states[:success]**2) + @q * (@states[:failure]**2) -
               (mean**2)
      end

      # The support set over which the distribution exists
      def support
        return @states.values.sort
      end

      # Compares two distribution instances and returns a boolean outcome
      #   Available publicly as #==
      #
      # @note This also compares the states over which the distribution exists
      #   in addition to he other parameters
      #
      # @private
      #
      # @param other A distribution object (preferred)
      # @return [Boolean] true if-and-only-if two instances are of the same
      #   class and have the same parameters.
      def eql?(other)
        return other.is_a?(self.class) &&
               @p == other.p &&
               @states == other.states
      end

      alias :== :eql?
      alias :p_value :quantile

      private :eql?
    end
  end
end
