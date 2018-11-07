require 'bundler'
Bundler.require
require_relative 'customer'
require_relative 'order'
require_relative 'supplier'
require_relative 'account'

StandaloneMigrations::Configurator.load_configurations
ActiveRecord::Base.establish_connection
ActiveRecord::Base.logger = Logger.new(STDOUT)
