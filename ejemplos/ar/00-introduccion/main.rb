require 'bundler'
Bundler.require
require_relative 'product'

# DB_NAME environment variable can be used to specify some other DB_NAME than
# /tmp/sample.db
ActiveRecord::Base.establish_connection adapter: 'sqlite3',
  database: ENV.fetch('DB_NAME', '/tmp/sample.db')

Product.all.each do |product|
  p product.name
end
