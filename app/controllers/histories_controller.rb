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
    # keys = {}
    PowerHistory.where("created_at > ?", 7.days.ago).group(:created_at).sum(:followers_sum).each do |k, v|
      key = k.to_date.strftime("%y%m%d")
      @chart_data[key] = v
    end
  end

end