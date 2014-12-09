class Target < ActiveRecord::Base
  has_many :accounts

  enum status: { following: 10, finished: 20 }

  scope :by_status, -> status {
    where(status: Target.statuses[status])
  }
end
