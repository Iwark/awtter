namespace :twitter do
  # descの記述は必須
  desc "Follower Get"

  # :environment は モデルにアクセスするのに必須
  task follow: :environment do
    Account.next_accounts().each do |account|
      followed = account.follow_target_users(account.target)
      followed.each { |f| puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{account.name} followed #{f.name} (#{f.id})"}
    end
  end

  task unfollow: :environment do
    Account.next_accounts().each do |account|
      unfollowed = account.unfollow_users()
      unfollowed.each { |f| puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{account.name} unfollowed #{f.name} (#{f.user_id})"}
    end
  end

  task retweet: :environment do
    retweets = Retweet.next_retweets
    retweets.each do |retweet|
      group = retweet.group
      max_num = 0
      if group
        max_num = group.accounts.count
      else
        max_num = Account.count
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
      
      account = nil
      if group
        account = group.accounts.where.not(id: account_ids).first
      else
        account = Account.where.not(id: account_ids).first
      end

      account.retweet(retweet)

      puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{account.name} successfully retweeted #{retweet.status_id}"

    end
  end

end
