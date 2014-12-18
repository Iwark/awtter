# == Schema Information
#
# Table name: power_histories
#
#  id            :integer          not null, primary key
#  followers_sum :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class PowerHistory < ActiveRecord::Base
end
