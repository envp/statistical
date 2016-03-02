require 'statistical/rng/uniform'
require 'statistical/rng/uniform_discrete'

module Statistical
  module Rng
    # @private
    # No need to document this
    # Dynamically add constants when called
    def self.const_missing(cname)
      const_set(cname, make_classmap) if cname == :RNG_TYPES
    end

    def self.create(type = :uniform, *args, &block)
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
