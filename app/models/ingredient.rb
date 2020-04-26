class Ingredient < ApplicationRecord
  #attr_accessor :name
  has_and_belongs_to_many :burgers
end
