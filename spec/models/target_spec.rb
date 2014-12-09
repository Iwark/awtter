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

require 'rails_helper'

RSpec.describe Target, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
