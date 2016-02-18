require 'statistical/rng/uniform'
require 'statistical/distribution'

module Statistical
  module Rng
    def self.create(type = :uniform, *args)
      dist_type = Statistical::Distribution::DISTRIBUTION_TYPES[type]
    end
  end
end
