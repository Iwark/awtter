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
#  pattern             :integer
#

class Account < ActiveRecord::Base

  belongs_to :group
  has_many :followed_users

  # validates :api_key, length: { is: 21 }
  # validates :api_secret, length: { is: 42 }
  # validates :access_token, length: { is: 50 }
  # validates :access_token_secret, length: { is: 42 }

  def get_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = self.api_key
      config.consumer_secret     = self.api_secret
      config.access_token        = self.access_token
      config.access_token_secret = self.access_token_secret
    end
  end

  # 前回updateされてから72分以上経った、
  # targetのあるアカウントをn個取得する
  def self.next_accounts(n=15)
    self.where.not(target: ["", nil]).where("updated_at < ?", DateTime.now - 72.minutes).order(:updated_at).limit(n)
  end

  # ターゲットを15人までfollowする
  def follow_target_users(target, n=10)
    client = self.get_client
    get_followers_count(client)
    
    # ユーザーの取得
    user = nil
    begin
      user = client.user(target)
    rescue => e
      puts "finding user of #{self.name} target(#{target}) error:#{e}"
      return []
    ensure
    end
    
    # フォロワーの取得
    follower_ids = nil
    begin
      follower_ids = client.follower_ids(user)
    rescue => e
      puts "finding follower_ids of #{self.name} target(#{target}) error:#{e}"
      return []
    ensure
    end

    followers = follower_ids.to_a.shuffle!
    followed = follow_users(client, followers, n)
    self.updated_at = DateTime.now
    self.save
    followed
  end

  # 48時間以上経ってフォロバの無いアカウントはフォローを削除する
  def unfollow_users(n=10)
    unfollowed = []
    client = self.get_client
    self.followed_users.where(checked: false).where("created_at < ?", DateTime.now - 48.hours).limit(n).each do |user|
      
      # 友達になっているかどうかのチェック
      is_friend = false
      begin
        is_friend = client.friendship?(client, user.user_id)
      rescue => e
        puts "is_friend error:#{e}"
        next
      ensure
      end

      unless is_friend
        # フォロー解除
        begin
          client.unfollow(user.user_id)
        rescue => e
          puts "unfollow failed:#{e}"
          next
        ensure
        end
        user.status = "unfollowed"
        unfollowed << user
      end
      user.checked = true
      user.save
    end
    self.update(updated_at: DateTime.now) if unfollowed.length > 0
    unfollowed
  end

  private

  # フォロワーの数を取得
  def get_followers_count(client)
    self.follower_num = client.user.followers_count
  end

  def follow_users(client, users, n)
    followed = []
    i = 1
    users.each do |u|
      return followed if i > n
      unless FollowedUser.exists?(user_id: u)
        f = nil
        begin
          f = client.follow(u)
        rescue => e
          puts "follow error:#{e}"
          return followed if /limit/.match(e)
        ensure
        end
        unless f.blank? || f[0].id.blank?
          FollowedUser.create(user_id: f[0].id.to_i, account_id: self.id, name: f[0].name, status:"followed", checked: false)
          followed << f[0]
          i += 1
        end
      end
    end
    followed
  end
end
