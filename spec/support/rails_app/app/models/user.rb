class User < ActiveRecord::Base
  has_many :events

  validates :name, presence: true, allow_blank: false

end
