# == Schema Information
#
# Table name: accounts
#
#  id                       :integer          not null, primary key
#  name                     :string(255)
#  api_key                  :string(255)
#  api_secret               :string(255)
#  access_token             :string(255)
#  access_token_secret      :string(255)
#  description              :string(255)
#  group_id                 :integer
#  created_at               :datetime
#  updated_at               :datetime
#  pattern                  :integer
#  follower_num             :integer          default(0)
#  follow_num               :integer          default(0)
#  followed_at              :datetime         default(2014-12-04 00:20:57 UTC)
#  unfollowed_at            :datetime         default(2014-12-04 00:20:57 UTC)
#  auto_retweet             :boolean          default(FALSE)
#  auto_retweeted_at        :datetime         default(2014-12-04 00:20:57 UTC)
#  auto_tweeted_at          :datetime         default(2014-12-07 06:27:11 UTC)
#  auto_tweet               :boolean          default(FALSE)
#  target_id                :integer
#  auto_follow              :boolean          default(TRUE)
#  auto_unfollow            :boolean          default(TRUE)
#  auto_retweet_target      :string(255)
#  target_auto_retweeted_at :datetime         default(2015-01-01 06:31:46 UTC)
#  auto_refollow            :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :account do
    name "MyString"
api_key "MyString"
api_secret "MyString"
access_token "MyString"
access_token_secret "MyString"
target "MyString"
description "MyString"
group_id "MyString"
  end

end
