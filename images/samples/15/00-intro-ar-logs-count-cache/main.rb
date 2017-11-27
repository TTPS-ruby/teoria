require 'bundler'
Bundler.require
require_relative 'product'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: '/tmp/sample.db'

Product.all.each do |product|
  p "#{product.class}: #{product.name}"
end

ActiveRecord::Base.logger = Logger.new(STDOUT)

#Product.last.items.create name: 'new_item'
