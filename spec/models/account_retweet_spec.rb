# == Schema Information
#
# Table name: account_retweets
#
#  id         :integer          not null, primary key
#  account_id :integer
#  retweet_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe AccountRetweet, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
