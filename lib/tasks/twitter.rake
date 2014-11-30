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

end
