# == Schema Information
#
# Table name: followed_users
#
#  id         :integer          not null, primary key
#  account_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#  checked    :boolean
#  status     :integer
#

class FollowedUser < ActiveRecord::Base
  belongs_to :account

  enum status: { followed: 10, unfollowed: 20}
end
