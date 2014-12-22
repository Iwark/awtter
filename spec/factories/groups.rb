# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  server_id  :integer          default(1)
#

FactoryGirl.define do
  factory :group do
    name "MyString"
  end

end
