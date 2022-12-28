require "simplecov"

require "minitest/autorun"

SimpleCov.start do
  add_filter "version.rb"
  add_filter "test"
end
require "triad"
