# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  tweet_id   :string(255)
#  text       :string(255)
#  account_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Tweet < ActiveRecord::Base
  belongs_to :account
end
