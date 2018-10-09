require 'minitest/reporters'
require_relative 'test'

Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(:color => true)]
