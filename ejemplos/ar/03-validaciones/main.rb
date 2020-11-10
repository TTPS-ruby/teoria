require 'bundler'
Bundler.require

require_relative 'models/person'

StandaloneMigrations::Configurator.new
StandaloneMigrations::Configurator.load_configurations
ActiveRecord::Base.establish_connection
