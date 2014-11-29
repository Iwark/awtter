# == Schema Information
#
# Table name: statements
#
#  id         :integer          not null, primary key
#  contents   :string(255)
#  priority   :integer
#  pattern    :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :statement do
    contents "MyString"
priority 1
pattern 1
  end

end
