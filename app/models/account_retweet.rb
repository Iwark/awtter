# == Schema Information
#
# Table name: account_retweets
#
#  id         :integer          not null, primary key
#  account_id :integer
#  retweet_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class AccountRetweet < ActiveRecord::Base
  belongs_to :account
  belongs_to :retweet
end
