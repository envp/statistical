require 'statistical/distribution/uniform'
require 'statistical/distribution/uniform_discrete'
require 'statistical/distribution/two_point'
require 'statistical/distribution/bernoulli'

module Statistical
  module Distribution
    # @private
    # No need to document this
    # Dynamically add constants when called
    def self.const_missing(cname)
      const_set(cname, make_classmap) if cname == :DISTRIBUTION_TYPES
    end

    def self.create(type = :uniform, *args, &block)
      DISTRIBUTION_TYPES[type].new(*args, &block)
    end

    def self.make_classmap
      dist_klasses = constants.select { |k| const_get(k).is_a?(Class)}
      keylist = dist_klasses.map { |k| k.to_s.snakecase.to_sym}
      klasses = dist_klasses.map { |k| const_get(k)}
      return Hash[keylist.zip(klasses)].freeze
    end

    private_class_method :make_classmap
  end
end
