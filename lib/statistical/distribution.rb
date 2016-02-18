require 'statistical/distribution/uniform'

module Statistical
  module Distribution
    # :nodoc:
    # Dynamically add constants when called
    def self.const_missing(cname)
      if cname == 'DISTRIBUTION_TYPES'.to_sym
        self.const_set(cname, make_classmap)
      end
    end
    
    def self.create(type = :uniform, *args)
      DISTRIBUTION_TYPES[type].new(*args)
    end
    
    private
    def self.make_classmap
      rng_klasses = self.constants.select{ |k| self.const_get(k).is_a?(Class) }
      keylist = rng_klasses.map { |k| k.to_s.downcase.to_sym }
      klasses = rng_klasses.map { |k| self.const_get(k) }
      return Hash[keylist.zip(klasses)].freeze
    end
  end
end
