require 'statistical/version'
require 'statistical/distribution'
require 'statistical/rng'
require 'statistical/core_extensions'

module Statistical
  using Statistical::StringExtensions
  using Statistical::ArrayExtensions

  # Truncated Euler-Mascheroni constant
  EULER_GAMMA = 0.5772156649015328
end
