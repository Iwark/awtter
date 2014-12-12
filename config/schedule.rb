# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

env :PATH, ENV['PATH']

set :output, "log/crontab.log"
set :environment, :production

# ログの同期
every 1.minutes do
  rake "cronlog:sync"
end

# フォロー
every 4.minutes do
  rake "twitter:follow"
end

# フォロー解除
every 16.minutes do
  rake "twitter:unfollow"
end

# ツイート自動化
every 7.minutes do
  rake "twitter:auto_tweet"
end

# リツイート
every 2.minutes do 
  rake "twitter:retweet"
end

# リツイート自動化
every 26.minutes do
  rake "twitter:auto_retweet"
end