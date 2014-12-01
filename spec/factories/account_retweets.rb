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

FactoryGirl.define do
  factory :account_retweet do
    account_id 1
retweet_id 1
  end

end
