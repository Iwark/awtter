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

class Statement < ActiveRecord::Base
  validates :contents, length: { maximum: 140 }

  # def hct_
end
