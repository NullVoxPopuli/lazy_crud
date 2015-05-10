class Discount < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :event
end
