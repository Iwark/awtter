# == Schema Information
#
# Table name: targets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  status     :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :target do
    name "MyString"
status 1
  end

end
