require 'statistical/exceptions'
require 'statistical/distribution/two_point'

module Statistical
  module Distribution
    # This is a convenience class implemented for syntactic sugar.
    # `TwoPoint.new(p)` already mimics and is infact the behaviour of this class
    #
    # @note The states used to represent success & failure must be Numeric.
    #   Using it on generic state lables can cause strange outcomes!
    #
    # @note state_failure < state_sucesss, for the sake of sanity.
    #
    # @author Vaibhav Yenamandra
    # @attr_reader [Float] p probability of the success state (= 1)
    # @attr_reader [Float] q probability of the failure state (= 0)
    class Bernoulli < TwoPoint
      # This is probably the best but the least descriptive variable name
      # attr_reader @p, @q

      # Returns a new instance of the Bernoulli distribution
      #
      # @param [Float] prob_success The probability of success
      def initialize(prob_success = 0.5)
        super(prob_success)
        self
      end
    end
  end
end
