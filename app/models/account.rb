# == Schema Information
#
# Table name: accounts
#
#  id                       :integer          not null, primary key
#  name                     :string(255)
#  api_key                  :string(255)
#  api_secret               :string(255)
#  access_token             :string(255)
#  access_token_secret      :string(255)
#  description              :string(255)
#  group_id                 :integer
#  created_at               :datetime
#  updated_at               :datetime
#  pattern                  :integer
#  follower_num             :integer          default(0)
#  follow_num               :integer          default(0)
#  followed_at              :datetime         default(2014-12-04 00:20:57 UTC)
#  unfollowed_at            :datetime         default(2014-12-04 00:20:57 UTC)
#  auto_retweet             :boolean          default(FALSE)
#  auto_retweeted_at        :datetime         default(2014-12-04 00:20:57 UTC)
#  auto_tweeted_at          :datetime         default(2014-12-07 06:27:11 UTC)
#  auto_tweet               :boolean          default(FALSE)
#  target_id                :integer
#  auto_follow              :boolean          default(TRUE)
#  auto_unfollow            :boolean          default(TRUE)
#  auto_retweet_target      :string(255)
#  target_auto_retweeted_at :datetime         default(2015-01-01 06:31:46 UTC)
#  auto_refollow            :boolean          default(FALSE)
#

class Account < ActiveRecord::Base

  belongs_to :target
  belongs_to :group, touch: true
  has_many :followed_users
  has_many :account_retweets
  has_many :tweets
  has_many :retweets, through: :account_retweets

  acts_as_taggable

  # 前回followしてから66分以上経った、
  # targetのあるアカウントをn個取得する
  scope :next_follow_accounts, -> n=30 {
    where(auto_follow: true).
    where(target_id: Target.by_status(:following).ids).
    where(arel_table[:followed_at].lt 66.minutes.ago).
    order(:followed_at).
    limit(n)
  }

  # 前回unfollowしてから120分以上経ったアカウントをn個取得する
  scope :next_unfollow_accounts, -> n=30 {
    where(auto_unfollow: true).
    where(arel_table[:unfollowed_at].lt 72.minutes.ago).
    order(:unfollowed_at).
    limit(n)
  }

  # 前回tweetしてから7分以上経ったアカウントをn個取得する
  scope :next_auto_tweet_accounts, -> n=15 {
    where(auto_tweet: true).
    where(arel_table[:auto_tweeted_at].lt 7.minutes.ago).
    order(:auto_tweeted_at).
    limit(n)
  }

  # 前回auto_retweetしてから3時間以上経ったアカウントをn個取得する
  scope :next_auto_retweet_accounts, -> n=15 {
    where(auto_retweet: true).
    where(arel_table[:auto_retweeted_at].lt 3.hours.ago).
    order(:auto_retweeted_at).
    limit(n)
  }

  # 前回target_auto_retweetしてから12時間以上経ったアカウントをn個取得する
  scope :next_target_auto_retweet_accounts, -> n=15 {
    where.not(auto_retweet_target: ["", nil]).
    where(arel_table[:target_auto_retweeted_at].lt 12.hours.ago).
    order(:target_auto_retweeted_at).
    limit(n)
  }

  # クライアントの取得
  def get_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = self.api_key
      config.consumer_secret     = self.api_secret
      config.access_token        = self.access_token
      config.access_token_secret = self.access_token_secret
    end
  end

  # ターゲットを10人までfollowする
  def follow_target_users(target, n=10)

    # クライアントの取得
    client = self.get_client

    # ユーザー情報の取得
    self_user = get_user(client, self.name)
    return [] unless self_user

    self_friend_ids = get_friend_ids(client, self_user)
    self_follower_ids = get_follower_ids(client, self_user)
    return [] unless self_friend_ids || self_follower_ids

    # フォロー数とフォロワー数の調整
    self.follow_num = self_friend_ids.length
    self.follower_num = self_follower_ids.length
    self.followed_at = DateTime.now
    self.save

    # 1.1 rule
    if self.follow_num > 2000 && self.follow_num > self.follower_num * 1.1 - 10
      $stderr.puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{self.name} is under the 1.1 rule."
      return []
    end

    # 片思われの取得
    one_side_follower_ids = get_one_side_follower_ids(self_friend_ids, self_follower_ids)

    # ターゲット情報の取得
    target_user = get_user(client, target)
    return [] unless target_user

    target_follower_ids = get_follower_ids(client, target_user)
    return [] unless target_follower_ids

    # フォローしにいく対象（自動フォロー返しがtrueなら先に行う）
    follow_targets = target_follower_ids
    follow_targets = (one_side_follower_ids + follow_targets).uniq if self.auto_refollow

    follow_users(client, follow_targets, n)
  end

  # 48時間以上経ってフォロバの無いアカウントはフォローを削除する
  def unfollow_users(n=15)

    client = self.get_client

    # ユーザー情報の取得
    user = get_user(client, self.name)
    return [] unless user

    friend_ids = get_friend_ids(client, user)
    follower_ids = get_follower_ids(client, user)
    return [] unless friend_ids || follower_ids

    # フォロー数とフォロワー数の調整
    self.follow_num = friend_ids.length
    self.follower_num = follower_ids.length
    self.unfollowed_at = DateTime.now
    self.save

    unfollowed = []

    # 48時間以上経って、フォロバの無いアカウント
    self.followed_users.old_ones.followed_or_not_checked.limit(n).each do |followed_user|

      # フォロー中かどうか
      is_friend = friend_ids.include?(followed_user.user_id.to_i)

      # フォロー中でなければ、リストから削除
      unless is_friend
        followed_user.status = :deleted 
        followed_user.checked = true
        followed_user.save
        next
      end

      # フォロワーかどうか
      is_follower = follower_ids.include?(followed_user.user_id.to_i)

      # フォロワーでなければ、フォローを解除
      unless is_follower
        begin
          client.unfollow(followed_user.user_id.to_i)
        rescue => e
          $stderr.puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{self.name} unfollow #{user.user_id} failed:#{e}"
          next
        ensure
        end
        followed_user.status = "unfollowed"
        unfollowed << followed_user
        followed_user.checked = true
        followed_user.save
      else
        followed_user.status = "friend"
        followed_user.checked = true
        followed_user.save
      end
    end
    unfollowed
  end

  def follow_follower(user_id)
    client = self.get_client
    f = nil
    begin
      f = client.follow(user_id.to_i)
    rescue => e
      $stderr.puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{self.name} follow error:#{e}"
    ensure
    end

    name = nil

    if f.blank? || f[0].id.blank?
      puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{self.name} failed to follow #{u} maybe this account is already followed."
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
      $stderr.puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{self.name} search tweets failed:#{e}"
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
          $stderr.puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{self.name} tweet failed:#{e}"
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

  # 自動ターゲットリツイートの作成
  def create_target_auto_retweet()
    client = self.get_client
    user = get_user(client, self.auto_retweet_target)
    if user
      Retweet.create(url: user.status.url.to_s, account_id: self.id, start_at: DateTime.now, interval: 0, frequency: 25)
      self.update(target_auto_retweeted_at: DateTime.now)
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
      $stderr.puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{self.name} retweet error:#{e}"
      return
    ensure
    end
    self.retweets << retweet
  end



  private

  # ユーザーの取得
  def get_user(client, target=nil)
    user = nil
    begin
      user = client.user(target)
    rescue => e
      $stderr.puts "#{DateTime.now.strftime("%m/%d %H:%M")}: finding user of #{self.name} target(#{target}) error:#{e}"
      return nil
    ensure
    end
    user
  end

  # フレンドの取得
  def get_friend_ids(client, user)
    friend_ids = nil
    begin
      friend_ids = client.friend_ids(user).to_a
    rescue => e
      $stderr.puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{self.name} failed to get info to unfollow users error:#{e}"
    ensure
    end
    return friend_ids
  end

  # フォロワーの取得
  def get_follower_ids(client, user)
    follower_ids = nil
    begin
      follower_ids = client.follower_ids(user, count: 5000).to_a
    rescue => e
      $stderr.puts "#{DateTime.now.strftime("%m/%d %H:%M")}: finding follower_ids of #{self.name} target(#{target}) error:#{e}"
    ensure
    end
    return follower_ids
  end

  # 片思われの取得
  def get_one_side_follower_ids(friend_ids, follower_ids)
    one_side_follower_ids = []
    follower_ids.each do |follower_id|
      one_side_follower_ids << follower_id if !friend_ids.include?(follower_id)
    end
    return one_side_follower_ids
  end

  def follow_users(client, users, n)
    followed = []
    i = 1
    users.each do |u|
      return followed if i > n
      next if FollowedUser.exists?(user_id: u)

      user = get_user(client, u)
      if !user
        FollowedUser.create(user_id: u, account_id: self.id, status:"deleted", checked: true)
        next
      end

      if user.protected?
        FollowedUser.create(user_id: u.to_i, account_id: self.id, status:"protecting", checked: true)
        i += 1
        next
      end

      f = nil
      begin
        f = client.follow(u)
      rescue => e
        $stderr.puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{self.name} follow error:#{e}"
        return followed if /limit/.match(e.to_s)
      ensure
      end

      name = nil

      if f.blank? || f[0].id.blank?
        puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{self.name} failed to follow #{u} maybe this account is already followed."
      else
        name = f[0].name
      end

      FollowedUser.create(user_id: u.to_i, account_id: self.id, name: name, status:"followed", checked: false)
      followed << u
      i += 1

    end
    self.target.update(status: :finished)
    puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{self.name} finished following the target followers."
    followed
  end

end
