class HistoriesController < ApplicationController

  # 一覧
  def index
    lg = IO.readlines("log/history.log")
    @histories = lg
    @histories = lg[-100..-1] if lg.length > 100

    lg = IO.readlines("log/error.log")
    @errors = lg
    @errors = lg[-100..-1] if lg.length > 100

    @chart_data = {}
    PowerHistory.where("created_at > ?", 7.days.ago).group(:created_at).sum(:followers_sum).each do |k, v|
      @chart_data[k] = v
    end
  end

  # クリア
  def clear
    file_name = "log/error.log"    #保存するファイル名

    File.open(file_name, 'w') {|file|
     file.write DateTime.now.strftime("----- cleared %m/%d %H:%M")
    }
    redirect_to '/histories'
  end

end