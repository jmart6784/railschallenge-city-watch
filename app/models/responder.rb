class Responder < ActiveRecord::Base
  self.inheritance_column = nil

  validates_numericality_of :capacity, greater_than_or_equal_to: 1, less_than_or_equal_to: 5, message: 'is not included in the list'
  validates_uniqueness_of :name
end
