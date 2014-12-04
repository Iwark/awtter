# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  tweet_id   :integer
#  text       :string(255)
#  account_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Tweet < ActiveRecord::Base
end
