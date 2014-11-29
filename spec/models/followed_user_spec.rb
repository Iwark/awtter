# == Schema Information
#
# Table name: followed_users
#
#  id         :integer          not null, primary key
#  account_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#  checked    :boolean
#  status     :integer
#

require 'rails_helper'

RSpec.describe FollowedUser, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
