class Emergency < ActiveRecord::Base
  has_many :responders
end
