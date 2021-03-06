namespace :twitter do
  # descの記述は必須
  desc "Follower Get"

  # :environment は モデルにアクセスするのに必須
  task follow: :environment do
    Group.server(Settings.server_id).includes(:accounts).each do |group|
      group.accounts.next_follow_accounts.each do |account|
        followed = account.follow_target_users(account.target.name)
        if followed.length > 0
          puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{account.name} followed #{followed.length} accounts."
        end
      end
    end
  end

  task unfollow: :environment do
    Group.server(Settings.server_id).includes(:accounts).each do |group|
      group.accounts.next_unfollow_accounts.each do |account|
        unfollowed = account.unfollow_users()
        if unfollowed.length > 0
          puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{account.name} unfollowed #{unfollowed.length} accounts."
        end
      end
    end
  end

  task auto_tweet: :environment do
    # 朝8時まではツイートしない
    unless DateTime.now.hour < 8
      Group.server(Settings.server_id).includes(:accounts).each do |group|
        group.accounts.next_auto_tweet_accounts.each do |account|
          # 3%の確率でツイート
          account.create_auto_tweet() if rand(100) < 3
        end
      end
    end
  end

  task auto_retweet: :environment do
    # 朝8時まではリツイートしない
    unless DateTime.now.hour < 8
      Group.server(Settings.server_id).includes(:accounts).each do |group|
        group.accounts.next_auto_retweet_accounts.each do |account|
          # 5%の確率でリツイート
          account.create_auto_retweet() if rand(100) < 5
        end
      end
    end
  end

  task target_auto_retweet: :environment do
    Group.server(Settings.server_id).includes(:accounts).each do |group|
      group.accounts.next_target_auto_retweet_accounts.each do |account|
        # 1%の確率でリツイート
        account.create_target_auto_retweet() if rand(100) < 1
      end
    end
  end

  task retweet: :environment do
    # メインのみ
    if Settings.server_id == 1
      retweets = Retweet.next_retweets
      retweets.each do |retweet|
        max_num = 0
        account = nil
        group = nil

        if retweet.account_id > 0
          account = Account.find(retweet.account_id)
          max_num = 1
        else
          group = retweet.group
          if group
            max_num = group.accounts.count
          else
            max_num = Account.count
          end
        end

        account_retweets_num = retweet.account_retweets.count

        # 既に全てリツイートが終わっているか、スタートしてから24時間以上経っていたら終了
        if account_retweets_num >= max_num || retweet.start_at + 24.hours < DateTime.now
          retweet.update(status: :done)
          next
        end

        # 頻度が満たしていなければ、次へ
        if retweet.frequency < rand(100)
          next
        end

        # 最後にリツイートをしてからの間隔が条件を満たしていなければ、次へ
        last_account_retweet = retweet.account_retweets.last
        if last_account_retweet && DateTime.now < last_account_retweet.created_at + retweet.interval.minutes
          next
        end

        # リツイート
        account_ids = []
        retweet.account_retweets.group(:account_id).select(:account_id).each do |ar|
          account_ids << ar.account_id
        end

        if !account && group
          account = group.accounts.where.not(id: account_ids).first
        elsif !account
          account = Account.where.not(id: account_ids).first
        end

        account.retweet(retweet)

        puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{account.name} successfully retweeted #{retweet.status_id}"

      end
    end
  end

end
