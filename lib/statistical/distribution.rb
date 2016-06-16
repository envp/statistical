require 'statistical/distribution/uniform'
require 'statistical/distribution/uniform_discrete'
require 'statistical/distribution/two_point'
require 'statistical/distribution/bernoulli'
require 'statistical/distribution/exponential'
require 'statistical/distribution/laplace'
require 'statistical/distribution/weibull'

module Statistical
  # Factory module used to create instances of various distributions classes
  # nested under itself
  module Distribution
    # @private
    # No need to document this
    # Dynamically add constants when called
    def self.const_missing(cname)
      const_set(cname, make_classmap) if cname == :DISTRIBUTION_TYPES
    end

    # Create a distribution identified by the type hash
    # @raise ArgumentError if `type` was not found
    def self.create(type = :uniform, *args, &block)
      raise ArgumentError unless DISTRIBUTION_TYPES.include?(type)
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
