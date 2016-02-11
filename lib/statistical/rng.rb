require 'statistical/rng/uniform'

module Statistical
  module Rng
    DISTRIBUTION_TYPES = {
      uniform: Uniform
    }.freeze

    def self.create(type = :uniform, *args)
      DISTRIBUTION_TYPES[type].new(*args)
    end
  end
end
