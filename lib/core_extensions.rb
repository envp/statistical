# All core class modifications go here
String.class_eval do
  
  # Convert CamelCase to snake_case
  def snakecase
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
  
  # convert snake_case to CamelCase
  def camelcase
    self.split('_').map(&:capitalize).join
  end
end

Array.class_eval do
  def sum
    self.inject(:+)
  end
  
  def mean
    sum / count
  end
  
  def sample_variance
    map {|x| (x - mean) ** 2}.sum.fdiv(count - 1)
  end
  
  def comprehend(&block)
    return self if block.nil?
    self.collect(&block).compact
  end
end