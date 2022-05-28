require 'simplecov'

require 'minitest/autorun'
require 'mutant/minitest/coverage'

SimpleCov.start do
  add_filter 'version.rb'
  add_filter 'test'
end
require 'triad'
