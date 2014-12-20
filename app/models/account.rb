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
#  description         :string(255)
#  group_id            :integer
#  created_at          :datetime
#  updated_at          :datetime
#  pattern             :integer
#  follower_num        :integer          default(0)
#  follow_num          :integer          default(0)
#  followed_at         :datetime         default(2014-12-02 01:25:53 UTC)
#  unfollowed_at       :datetime         default(2014-12-02 01:25:53 UTC)
#  auto_retweet        :boolean          default(FALSE)
#  auto_retweeted_at   :datetime         default(2014-12-03 06:55:17 UTC)
#  auto_tweeted_at     :datetime         default(2014-12-04 10:24:06 UTC)
#  auto_tweet          :boolean          default(FALSE)
#  target_id           :integer
#  auto_follow         :boolean          default(TRUE)
#  auto_unfollow       :boolean          default(TRUE)
#

class Account < ActiveRecord::Base

  belongs_to :target
  belongs_to :group, touch: true
  has_many :followed_users
  has_many :account_retweets
  has_many :tweets
  has_many :retweets, through: :account_retweets

  acts_as_taggable

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

  # 前回followしてから72分以上経った、
  # targetのあるアカウントをn個取得する
  def self.next_follow_accounts(n=30)
    self.where(auto_follow: true).where.not(target: ["", nil]).where("followed_at < ?", DateTime.now - 72.minutes).order(:followed_at).limit(n)
  end

  # 前回unfollowしてから120分以上経ったアカウントをn個取得する
  def self.next_unfollow_accounts(n=30)
    self.where(auto_unfollow: true).where("unfollowed_at < ?", DateTime.now - 120.minutes).order(:unfollowed_at).limit(n)
  end

  # 前回auto_tweetしてから7分以上経ったアカウントをn個取得する
  def self.next_auto_tweet_accounts(n=15)
    self.where("auto_tweet = true and auto_tweeted_at < ?", DateTime.now - 7.minutes).order(:auto_tweeted_at).limit(n)
  end

  # 前回auto_retweetしてから3時間以上経ったアカウントをn個取得する
  def self.next_auto_retweet_accounts(n=15)
    self.where("auto_retweet = true and auto_retweeted_at < ?", DateTime.now - 3.hours).order(:auto_retweeted_at).limit(n)
  end

  # ターゲットを10人までfollowする
  def follow_target_users(target, n=10)
    client = self.get_client
    get_follow_count(client)
    get_followers_count(client)
    
    if self.target.status == "finished"
      puts "#{self.name} canceled following because target status is finished."
      self.followed_at = DateTime.now
      self.save
      return []
    end

    if self.follow_num > 2000 && self.follow_num > self.follower_num * 1.1 - 10
      puts "#{self.name} is under the 1.1 rule."
      self.followed_at = DateTime.now
      self.save
      return []
    end

    # ユーザーの取得
    user = get_user(client, target)
    return [] unless user
    
    # フォロワーの取得
    follower_ids = nil
    begin
      follower_ids = client.follower_ids(user, count: 5000)
    rescue => e
      $stderr.puts "finding follower_ids of #{self.name} target(#{target}) error:#{e}"
      return []
    ensure
    end

    followers = follower_ids.to_a.shuffle!
    followed = follow_users(client, followers, n)
    self.followed_at = DateTime.now
    self.save
    followed
  end

  # 48時間以上経ってフォロバの無いアカウントはフォローを削除する
  def unfollow_users(n=15)
    unfollowed = []
    client = self.get_client

    friend_ids = []
    follower_ids = []

    begin
      friend_ids = client.friend_ids.to_a
    rescue => e
      $stderr.puts "#{self.name} failed to get info to unfollow users error:#{e}"
      self.update(unfollowed_at: DateTime.now)
      return []
    ensure
    end

    begin
      follower_ids = client.follower_ids.to_a
    rescue => e
      $stderr.puts "#{self.name} failed to get info to unfollow users error:#{e}"
      self.update(unfollowed_at: DateTime.now)
      return []
    ensure
    end

    # 片想われの検出
    i = 0
    follower_ids.each do |follower_id|
      if !FollowedUser.exists?(user_id: follower_id, account_id: self.id) && !friend_ids.include?(follower_id)
        if i < 3
          user = get_user(client, follower_id)
          FollowedUser.create(user_id: follower_id, name: user.screen_name, account_id: self.id, status:"follower", checked: true)
          i += 1
        end
      end
    end

    self.followed_users.old_ones.followed_or_not_checked.limit(n).each do |user|
      
      # フォロー中かどうか
      is_friend = friend_ids.include?(user.user_id.to_i)

      # フォロー中でなければ、リストから削除
      unless is_friend
        user.status = :deleted 
        user.checked = true
        user.save
        next
      end

      # フォロワーかどうか
      is_follower = follower_ids.include?(user.user_id.to_i)

      unless is_follower
        # フォロー解除
        begin
          client.unfollow(user.user_id.to_i)
        rescue => e
          $stderr.puts "#{self.name} unfollow #{user.user_id} failed:#{e}"
          next
        ensure
        end
        user.status = "unfollowed"
        unfollowed << user
        user.checked = true
        user.save
      else
        user.status = "friend"
        user.checked = true
        user.save
      end
    end
    self.update(unfollowed_at: DateTime.now) if unfollowed.length > 0
    unfollowed
  end

  def follow_follower(user_id)
    client = self.get_client
    f = nil
    begin
      f = client.follow(user_id.to_i)
    rescue => e
      $stderr.puts "#{self.name} follow error:#{e}"
    ensure
    end

    name = nil

    if f.blank? || f[0].id.blank?
      puts "#{self.name} failed to follow #{u} maybe this account is already followed."
    else
      name = f[0].name
    end

    FollowedUser.find_by(user_id: user_id).update(status: "followed")

  end

  # 自動ツイートの作成
  def create_auto_tweet()
    client = self.get_client

    list = self.tag_list + self.group.tag_list
    return if list.length == 0

    tag = list[rand(list.length)]

    results = nil
    begin
      results = client.search(tag).to_h[:statuses]
    rescue => e
      $stderr.puts "#{self.name} search tweets failed:#{e}"
      return
    ensure
    end

    results.each do |result|

      next if Tweet.exists?(tweet_id: result[:id].to_s)

      # リツイートは多すぎないものにする。
      if result[:retweet_count] < 10
        
        # URLを含むツイートはしない
        if result[:entities][:urls].length > 0 && result[:entities][:urls][0][:url]
          next
        end

        # リツイートはツイートしない
        if result[:entities][:user_mentions].length > 0
          next
        end
        
        # 画像を含むツイートはしない
        if result[:entities][:media] && result[:entities][:media].length > 0 && result[:entities][:media][0][:media_url]
          next
        end

        # フォロワーが1000人以上いるアカウントのツイートはしない
        if result[:user][:followers_count] > 1000
          next
        end

        # 語尾は敬語または敬語じゃないもので統一する
        unless result[:text].match(/(です|でした|ですよ|ました|ます)/)
          next
        end

        # １人称が俺・僕のものはツイートしない
        if result[:text].match(/(俺|僕)/)
          next
        end

        # 「拡散」という文字を含むものはツイートしない
        if result[:text].match(/拡散/)
          next
        end

        # 60文字以下のものにする。
        unless result[:text].length < 60
          next
        end

        # ハッシュタグのついてるものはツイートしない
        if result[:entities][:hashtags].length > 0
          next
        end

        # 数字が6つ以上含まれるものはツイートしない（電話番号や郵便番号など）
        if result[:text].gsub(/[^0-9]/,'').length >= 6
          next
        end

        begin
          client.update(result[:text])
        rescue => e
          $stderr.puts "#{self.name} tweet failed:#{e}"
          return
        ensure
        end
        
        Tweet.create(text: result[:text], account_id: self.id, tweet_id: result[:id].to_s)
        break

      end
    end
  end
  
  # 自動リツイートの作成
  def create_auto_retweet()
    client = self.get_client
    client.home_timeline.each do |tweet|
      if tweet.retweet_count > 2 && self.check_tweet(tweet.text)
        Retweet.create(url: tweet.url.to_s, account_id: self.id, start_at: DateTime.now, interval: 0, frequency: 5)
        self.update(auto_retweeted_at: DateTime.now)
        return
      end
    end
  end

  def check_tweet(text)
    if text.match(/(セフレ|エロ|サクラ|無料|神|万円|アフィリエイト|ゲーム|iOS|And|メアド|番号|アプリ|LINE|変態|ヤリマン|ビッチ|女)/i)
      return false
    else
      return true
    end
  end

  # リツイート
  def retweet(retweet)
    client = self.get_client
    begin
      client.retweet(retweet.status_id)
    rescue => e
      $stderr.puts "#{self.name} retweet error:#{e}"
      return
    ensure
    end
    self.retweets << retweet
  end

  private

  def get_user(client, target=nil)
    user = nil
    begin
      user = client.user(target)
    rescue => e
      $stderr.puts "finding user of #{self.name} target(#{target}) error:#{e}"
      return nil
    ensure
    end
    user
  end

  # フォローの数を取得
  def get_follow_count(client)
    user = get_user(client)
    return unless user
    self.follow_num = user.friends_count
  end

  # フォロワーの数を取得
  def get_followers_count(client)
    user = get_user(client)
    return unless user
    self.follower_num = user.followers_count
  end

  def follow_users(client, users, n)
    followed = []
    i = 1
    users.each do |u|
      return followed if i > n
      next if FollowedUser.exists?(user_id: u)

      user = get_user(client, u)
      next if !user

      if user.protected?
        FollowedUser.create(user_id: u.to_i, account_id: self.id, status:"protecting", checked: true)
        i += 1
        next
      end

      f = nil
      begin
        f = client.follow(u)
      rescue => e
        $stderr.puts "#{self.name} follow error:#{e}"
        return followed if /limit/.match(e.to_s)
      ensure
      end

      name = nil

      if f.blank? || f[0].id.blank?
        puts "#{self.name} failed to follow #{u} maybe this account is already followed."
      else
        name = f[0].name
      end

      FollowedUser.create(user_id: u.to_i, account_id: self.id, name: name, status:"followed", checked: false)
      followed << u
      i += 1

    end
    self.target.update(status: :finished)
    puts "#{self.name} finished following the target followers."
    followed
  end

end
