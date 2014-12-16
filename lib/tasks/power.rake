namespace :power do
  # descの記述は必須
  desc "Make Power History"

  # :environment は モデルにアクセスするのに必須
  task create: :environment do
    followers_sum = 0
    Group.all.each do |group|
      group.accounts.each do |account|
        followers_sum += account.follower_num
      end
    end
    PowerHistory.create(followers_sum: followers_sum)
  end

end

