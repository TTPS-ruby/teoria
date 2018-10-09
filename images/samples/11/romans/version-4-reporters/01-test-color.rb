require 'minitest/reporters'
require_relative 'test'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]
