namespace :twitter do
  # descの記述は必須
  desc "Follower Get"

  # :environment は モデルにアクセスするのに必須
  task follow: :environment do
    puts "-- #{DateTime.now.strftime("%m/%d %H:%M")}: twitter:follow"
    Account.next_accounts().each do |account|
      puts "account:#{account}"
      followed = account.follow_target_users(account.target)
      followed.each { |f| puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{account.name} followed #{f.name} (#{f.id})"}
    end
  end

  task unfollow: :environment do
    puts "-- #{DateTime.now.strftime("%m/%d %H:%M")}: twitter:unfollow"
    Account.next_accounts().each do |account|
      unfollowed = account.unfollow_users()
      unfollowed.each { |f| puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{account.name} unfollowed #{f.name} (#{f.user_id})"}
    end
  end

end
