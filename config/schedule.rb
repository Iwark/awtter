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
  rake "cronlog:sync", :output => {:error => 'log/sync.log', :standard => 'log/sync.log'}
end

every 5.minutes do
  rake "power:create"
end

# フォロー
every 5.minutes do
  rake "twitter:follow", :output => {:error => 'log/error.log', :standard => 'log/history.log'}
end

# フォロー解除
every 21.minutes do
  rake "twitter:unfollow", :output => {:error => 'log/error.log', :standard => 'log/history.log'}
end

# ツイート自動化
every 8.minutes do
  rake "twitter:auto_tweet", :output => {:error => 'log/error.log', :standard => 'log/history.log'}
end

# リツイート
every 3.minutes do 
  rake "twitter:retweet", :output => {:error => 'log/error.log', :standard => 'log/history.log'}
end

# リツイート自動化
every 29.minutes do
  rake "twitter:auto_retweet", :output => {:error => 'log/error.log', :standard => 'log/history.log'}
end