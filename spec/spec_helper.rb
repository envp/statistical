$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'statistical'
require 'statistics2'
require 'codacy-coverage'

Codacy::Reporter.start
