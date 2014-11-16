# == Schema Information
#
# Table name: accounts
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  api_key             :string(255)
#  api_secret          :string(255)
#  access_token        :string(255)
#  access_token_secret :string(255)
#  target              :string(255)
#  description         :string(255)
#  group_id            :string(255)
#  created_at          :datetime
#  updated_at          :datetime
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
