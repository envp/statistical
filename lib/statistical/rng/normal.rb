require 'statistical/distribution/normal'

module Statistical
  module Rng
    # Companion RNG class for the continuous Normal distribution. Requires a
    #   distrbution object of the corresponding distribution
    #
    # @author Vaibhav Yenamandra
    #
    # @attr_reader [Numeric] location parameter mu of the normal distribution
    # @attr_reader [Numeric] scale standard deviation of the normal distribution
    class Normal
      attr_reader :generator, :location, :scale

      def initialize(dobj = nil, seed = Random.new_seed)
        unless dobj.nil? || dobj.is_a?(Statistical::Distribution::Normal)
          raise TypeError,
                "Expected Distribution object or nil, found #{dobj.class}"
        end
        dobj = Statistical::Distribution::Normal.new if dobj.nil?
        @generator  = Random.new(seed)
        @location   = dobj.location
        @scale      = dobj.scale
        @sdist      = dobj
      end


      # Returns a standard normal deviate using the Kinderman-Monahan
      #   ratio method. This was taken from the GSL 1.14 source
      # :nodoc:
      private def rand_std_ratio_method
        u, v = 0, 0
        loop do
          u = 1 - @generator.rand

          # (8/e)**0.5 ~ 1.7155277699214135
          v = (@generator.rand - 0.5) * 1.71552777
          x = u - 0.449871
          y = v.abs + 0.386595
          q = x * x + y * (0.19600 * y - 0.25472 * x)
          break if q > 0.27597 && 
                   (q > 0.27846 || v * v > -4 * u * u * Math.log(u))
        end
        return v / u
      end

      # Return the next random number from the sequence. This method draws
      #   random samples from the normal distribution using the
      #   Kinderman-Monahan ratio method
      #
      # @return [Float] next random number in the sequence
      def rand
        return @location + @scale * rand_std_ratio_method
      end

      # Compare against another rng to see if they are the same
      #
      # @return true if and only if, source distributions are the same and the
      #   prng has the same initial state
      def eql?(other)
        return other.is_a?(self.class) &&
               @generator == other.generator &&
               @location  == other.location &&
               @scale     == other.scale
      end

      # Return the type of the source distribution
      #
      # @return source distribution's type
      def type
        @sdist.class
      end

      alias_method :==, :eql?
      private :eql?
    end
  end
end
