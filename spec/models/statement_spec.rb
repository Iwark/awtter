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

require 'rails_helper'

RSpec.describe Statement, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
