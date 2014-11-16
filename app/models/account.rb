# == Schema Information
#
# Table name: accounts
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  api_key             :string(255)
#  api_secret          :string(255)
#  access_token        :string(255)
#  access_token_secret :string(255)
#  target              :string(255)
#  description         :string(255)
#  group_id            :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class Account < ActiveRecord::Base

  belongs_to :group

  validates :api_key, length: { is: 21 }
  validates :api_secret, length: { is: 42 }
  validates :access_token, length: { is: 50 }
  validates :access_token_secret, length: { is: 42 }

  def get_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = self.api_key
      config.consumer_secret     = self.api_secret
      config.access_token        = self.access_token
      config.access_token_secret = self.access_token_secret
    end
  end

  def follow_target_users(target, n=10)
    client = self.get_client
    user = client.user(target)
    followers = client.follower_ids(user).to_a.shuffle!
    followed = follow_users(client, followers, n)
    self.update(updated_at: DateTime.now) if followed.length > 0
    followed
  end

  # 前回updateされてから72分以上経った、
  # targetのあるアカウントをn個取得する
  def self.next_accounts(n=5)
    self.where.not(target: ["", nil]).where("updated_at < ?", DateTime.now - 72.minutes).order(:updated_at).limit(n)
  end

  private
  def follow_users(client, users, n)
    followed = []
    i = 1
    users.each do |u|
      logger.info "u: #{u}"
      return followed if i >= n
      # f = client.user(u) rescue nil # useful for development
      # followed << f unless f.nil? || f.id.blank?
      f = client.follow(u)
      unless f.blank? || f[0].id.blank?
        followed << f[0]
      end
      i += 1
    end
    followed
  end
end
