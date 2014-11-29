namespace :twitter do
  # descの記述は必須
  desc "Follower Get"

  # :environment は モデルにアクセスするのに必須
  task follow: :environment do
    Account.next_accounts().each do |account|
      account.follow_target_users(account.target)
    end
  end

  task unfollow: :environment do
    Account.next_accounts().each do |account|
      account.unfollow_users()
    end
  end

end
