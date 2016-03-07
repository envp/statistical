require 'statistical/exceptions'
require 'statistical/distribution/bernoulli'
require 'statistical/rng/two_point'

module Statistical
  module Rng
    class Bernoulli < TwoPoint
      # Companion RNG class for the Bernoulli distribution. Requires a
      # distrbution object of the same type. Defaults to standard bernoulli
      # if arguments are unspecified
      #
      # @author Vaibhav Yenamandra
      #
      # @attr_reader [Float] p Probability of success state
      # @attr_reader [Float] q Probability of failure state
      # @attr_reader [Hash] states Possible states that the RNG can take up
      # @attr_reader [Random] generator The PRNG being used for randomness
      def initialize(dobj = nil, seed = Random.new_seed)
        unless dobj.nil? || dobj.is_a?(Statistical::Distribution::Bernoulli)
          raise TypeError, 
            "Expected Distribution object or nil, found #{dobj.class}"
        end
        dobj = Statistical::Distribution::Bernoulli.new if dobj.nil?
        super(dobj, seed)
      end
    end
  end
end
