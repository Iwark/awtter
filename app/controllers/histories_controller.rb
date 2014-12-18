class HistoriesController < ApplicationController

  # 一覧
  def index
    lg = IO.readlines("log/history.log")
    @histories = lg
    @histories = lg[-100..-1] if lg.length > 100

    lg = IO.readlines("log/error.log")
    @errors = lg
    @errors = lg[-100..-1] if lg.length > 100
  end

end