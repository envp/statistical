require 'statistical/rng/uniform'
require 'statistical/distribution'

module Statistical
  module Rng
    def self.create(type = :uniform, *args)
      Distribution::DISTRIBUTION_TYPES[type].new(*args)
    end
  end
end
