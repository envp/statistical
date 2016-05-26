require 'statistical/rng/uniform'
require 'statistical/rng/uniform_discrete'
require 'statistical/rng/two_point'
require 'statistical/rng/bernoulli'
require 'statistical/rng/exponential'

module Statistical
  # Factory module to create instances of the various classes 
  # nested under itself
  module Rng
    # @private
    # No need to document this
    # Dynamically add constants when called
    def self.const_missing(cname)
      const_set(cname, make_classmap) if cname == :RNG_TYPES
    end
    
    # Creates a new instance of the give type if the type was found.
    # 
    # @raises ArgumentError If the give type parameter was not found
    def self.create(type = :uniform, *args, &block)
      raise ArgumentError unless RNG_TYPES.include?(type)
      RNG_TYPES[type].new(*args, &block)
    end

    def self.make_classmap
      rng_klasses = constants.select { |k| const_get(k).is_a?(Class)}
      keylist = rng_klasses.map { |k| k.to_s.snakecase.to_sym}
      klasses = rng_klasses.map { |k| const_get(k)}
      return Hash[keylist.zip(klasses)].freeze
    end

    private_class_method :make_classmap
  end
end
