class User < ActiveRecord::Base
  has_many :events

  has_many :collaborated_events,
    through: :collaborations,
    source: :user
  has_many :collaborations

end
