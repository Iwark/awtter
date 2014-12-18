# == Schema Information
#
# Table name: targets
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  status      :integer
#  created_at  :datetime
#  updated_at  :datetime
#  description :string(255)
#

class Target < ActiveRecord::Base
  has_many :accounts

  enum status: { following: 10, finished: 20 }

  scope :by_status, -> status {
    where(status: Target.statuses[status])
  }
end
