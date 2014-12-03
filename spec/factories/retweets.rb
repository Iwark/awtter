# == Schema Information
#
# Table name: retweets
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  group_id   :integer
#  start_at   :datetime
#  interval   :integer
#  frequency  :integer
#  created_at :datetime
#  updated_at :datetime
#  status     :integer          default(0)
#  account_id :integer          default(0)
#

FactoryGirl.define do
  factory :retweet do
    url "MyString"
group_id 1
start_at "2014-12-01 10:39:11"
interval 1
frequency 1
  end

end
