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

class Retweet < ActiveRecord::Base

  belongs_to :group
  has_many :account_retweets
  has_many :accounts, through: :account_retweets

  enum status: { setup: 0, done: 10}

  scope :next_retweets, -> {
    where.not(status: Retweet.statuses[:done]).where("start_at < ?", DateTime.now)
  }

  def status_id
    status_id = url.gsub(/.*?\/status\/([0-9]+)(\/|\?)*/,'\1') if url.match(/.*?\/status\/([0-9]+)(\/|\?)*/)
    status_id = url.gsub(/.*?retweet\?tweet_id\=([0-9]+)\&*/,'\1') if url.match(/.*?retweet\?tweet_id\=([0-9]+)\&*/)
    status_id
  end


end
