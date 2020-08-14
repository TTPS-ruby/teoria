require_relative 'item'
class Product < ActiveRecord::Base
 has_many :items
end

class ProductA < Product; end
class ProductB < Product; end
