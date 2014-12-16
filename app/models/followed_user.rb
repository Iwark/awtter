# == Schema Information
#
# Table name: followed_users
#
#  id         :integer          not null, primary key
#  account_id :integer
#  user_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#  checked    :boolean
#  status     :integer
#

class FollowedUser < ActiveRecord::Base
  belongs_to :account

  enum status: { followed: 10, unfollowed: 20, protecting: 30, friend: 40, deleted: 50, follower: 60 }

  scope :by_status, -> status {
    where(status: FollowedUser.statuses[status])
  }

  # フォローしてから48時間以上たったもの
  scope :old_ones, -> {
    where(FollowedUser.arel_table[:created_at].lt(2.days.ago))
  }

  # followed または チェックしていないもの
  scope :followed_or_not_checked, -> {
    where(FollowedUser.arel_table[:status].eq(FollowedUser.statuses[:followed]).
    or(FollowedUser.arel_table[:checked].eq(:false)))
  }

end
