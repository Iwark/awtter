# == Schema Information
#
# Table name: retweets
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  group_id   :integer
#  start_at   :datetime
#  interval   :integer
#  frequency  :integer
#  created_at :datetime
#  updated_at :datetime
#  status     :integer          default(0)
#

require 'rails_helper'

RSpec.describe Retweet, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
