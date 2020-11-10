class Person < ActiveRecord::Base
  validates :name, presence: true
  validates :terminos, acceptance: true
  validates :name, format: { 
            with: /\A[a-zA-Z]+\z/,
            message: "only allows letters" }
end

