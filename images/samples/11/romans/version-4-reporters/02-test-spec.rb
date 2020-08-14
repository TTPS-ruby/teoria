require 'minitest/reporters'
require_relative 'test'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new(:color => true)]
