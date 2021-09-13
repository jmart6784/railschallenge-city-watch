class Emergency < ActiveRecord::Base
  has_many :responders

  validates_uniqueness_of :code

  validates_numericality_of :fire_severity, 
    greater_than_or_equal_to: 0, 
    message: 'must be greater than or equal to 0'

  validates_numericality_of :police_severity, 
    greater_than_or_equal_to: 0, 
    message: 'must be greater than or equal to 0'

  validates_numericality_of :medical_severity, 
    greater_than_or_equal_to: 0, 
    message: 'must be greater than or equal to 0'
end
