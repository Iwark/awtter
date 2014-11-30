class HistoriesController < ApplicationController

  # 一覧
  def index
    lg = IO.readlines("log/crontab.log")
    @log_lines = lg
    @log_lines = lg[-100..-1] if lg.length > 100
  end

end