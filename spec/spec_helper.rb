$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'statistical'
require 'statistics2'
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start
