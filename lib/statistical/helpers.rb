module Statistical
  # This class models a mathematical domain by basing it on Ruby's Range
  # Does not allow for enumeration of the domain unless. The primary addition
  # here is the addtion of an exclusion list which allows us to exclude specific
  # points and ranges from within the domain.
  #
  # @note If the exclusion list contains points outside of the base range these
  #   points are not validated. The user is expect to supply valid input, since
  #   this is a helper class
  # @note All instances of this class are returned frozen
  #
  # @author Vaibhav Yenamandra
  #
  # @attr_reader :exclusions The exclusion list of points and ranges to not
  #   be included in the domain. The list must be homogenous
  class Domain < Range
    include Comparable

    attr_reader :start, :finish, :exclusions, :domain_type

    TYPES = [
      :left_open,
      :right_open,
      :full_open,
      :closed
    ].freeze

    # Creates a new domain instance which can be one of the following types
    #   :left_open, :right_open, :full_open, :closed
    #   An exclusion list is also maintained to capture undesired points, ranges
    #
    # @param [Fixnum, Bignum] start number where the range starts
    # @param [Fixnum, Bignum] finish number where the range ends
    # @param [Symbol] domain_type kind of domain to represent
    # @param exclusions homogenous list of exclusions
    def initialize(start, finish, domain_type, *exclusions)
      exclusions ||= []
      exclude_end = false

      case domain_type
      when :left_open
        @exclusions = [start, exclusions].flatten
        exclude_end = false
      when :right_open
        @exclusions = [exclusions, finish].flatten
        exclude_end = true
      when :full_open
        @exclusions = [start, exclusions, finish].flatten
        exclude_end = true
      when :closed
        @exclusions = [exclusions].flatten
        exclude_end = false
      else
        raise ArgumentError,
              "Invalid domain type, must be one of #{DOMAIN_TYPES}"
      end
      @start = start
      @finish = finish
      @domain_type = domain_type

      super(@start, @finish, exclude_end)
    end

    # Returns a frozen new instance, overrides Range::new
    # @return [Domain] a new instance of the Domain class
    def new(*args)
      super(*args).freeze
    end

    # Returns a frozen new instance
    # @see #new
    # @return [Domain] a new instance of the Domain class
    def self.[](*args)
      new(*args)
    end

    # Find if a point value is part of the instance's exclusion list
    #
    # @param val The numeric value to test for exclusion
    # @return [Boolean] if the value is excluded from the current domain
    def exclude?(val)
      has_val = false
      @exclusions.each do |e|
        case e
        when Fixnum, Bignum, Float
          has_val = (has_val || (e == val))
        when Range
          has_val = (has_val || e.include?(val))
        end
      end
      return has_val
    end

    # Find if a point value is part of the domain
    #
    # @param val The value to test for inclusion
    # @return [Boolean] if the value is included in the current domain
    def include?(val)
      super(val) && !exclude?(val)
    end

    # Serialize the instance
    #
    # @see #to_s
    # @return [String] string representation of the Domain object
    def inspect
      return "[#{super}] - #{@exclusions}" unless @exclusions.empty?
      return super
    end

    # Compares Domain objects with Real numeric types (Fixnum, Bignum, Float)
    #
    # @param other the point to compare
    # @return -1 if the value lies to the left of the domain
    #   1 if the value lies to the right of domain
    #   0 if the value is included in the range
    #   nil if the two are not deemed comparable
    def <=>(other)
      case other
      when Fixnum, Bignum, Float
        return -1 if other <= @start && !include?(other)
        return  1 if other >= @finish && !include?(other)
        return  0 if include?(other)
      else
        # Not comparable
        return nil
      end
    end

    alias :to_s :inspect
  end
  
  # Useful truncated floating point constants that are automatically added
  # to the base class
  module Constants
    # Euler-Mascheroni constant
    EULER_GAMMA = 0.5772156649015328
    
    SQRT_2      = 1.4142135623730950
    SQRT_PI     = 1.7724538509055160
    SQRT_2PI    = 2.5066282746310005
    
    # Whenever this module is included in any class, that class is able
    # to access all of the above constants locally
    def self.included(cls)
      self.constants.each {|c| cls.send :const_set, c, self.const_get(c)}
    end
  end
end
