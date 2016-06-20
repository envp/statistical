# All core class modifications go here
module Statistical
  # Module to contain all String refinements
  module StringExtensions
    refine String do
      # Convert CamelCase to snake_case
      def snakecase
        gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_')
          .downcase
      end

      # convert snake_case to CamelCase
      def camelcase
        split('_').map(&:capitalize).join
      end
    end
  end

  # Module to contain all Array refinements
  module ArrayExtensions
    refine Array do
      def sum
        inject(:+)
      end

      def mean
        sum.fdiv(count)
      end

      # Population variance
      def pvariance
        map { |x| (x - mean)**2}.sum.fdiv(count)
      end

      # Sample variance
      def svariance
        map { |x| (x - mean)**2}.sum.fdiv(count - 1)
      end
    end
  end
end
