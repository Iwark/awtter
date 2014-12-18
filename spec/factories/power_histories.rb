# == Schema Information
#
# Table name: power_histories
#
#  id            :integer          not null, primary key
#  followers_sum :integer
#  created_at    :datetime
#  updated_at    :datetime
#

FactoryGirl.define do
  factory :power_history do
    followers_sum 1
  end

end
