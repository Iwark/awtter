namespace :twitter do
  # descの記述は必須
  desc "Follower Get"

  # :environment は モデルにアクセスするのに必須
  task get_followers: :environment do
    # Account.next_accounts(5).each do |account|
    #   puts "get_followers started ... #{account.name}"
    #   followed = account.follow_target_users(account.target) unless account.target.blank?
    #   followed.each { |f| puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{account.name} followed #{f.name} (#{f.id})"}
    # end
  end

  task follow_test: :environment do
    account = Account.first
    puts account
    followed = account.follow_target_users(account.target, 3)
    puts followed
    followed.each { |f| puts "#{DateTime.now.strftime("%m/%d %H:%M")}: #{account.name} followed #{f.name} (#{f.id})"}
  end

  task tasktest: :environment do
    puts "aaaaaaa"
  end

end
