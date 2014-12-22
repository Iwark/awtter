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

class Group < ActiveRecord::Base
  has_many :accounts
  has_many :retweets

  acts_as_taggable

  enum server_id: {
    Server1: 1,
    Server2: 2,
    Server3: 3,
    Server4: 4,
    Server5: 5
  }

  # サーバーごとに処理対象を分ける
  scope :server, -> server_id {
    where(server_id: server_id)
  }

end
