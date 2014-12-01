class RetweetsController < ApplicationController
  before_action :set_retweet, only: [:show, :edit, :update, :destroy]

  # 一覧
  def index
    @retweets = Retweet.all
  end

  def show
  end

  # 新規
  def new
    @retweet = Retweet.new
  end

  # 編集
  def edit
  end

  # 作成
  def create
    @retweet = Retweet.new(retweet_params)
    if @retweet.save
      redirect_to retweets_url, notice: 'retweet was successfully created.'
    else
      render :new
    end
  end

  # 更新
  def update
    if @retweet.update(retweet_params)
      redirect_to retweets_url, notice: 'retweet was successfully updated.'
    else
      render :edit
    end
  end

  # 削除
  def destroy
    @retweet.destroy
    redirect_to retweets_url, notice: 'retweet was successfully destroyed.'
  end

  private
    def set_retweet
      @retweet = Retweet.find(params[:id])
    end

    def retweet_params
      params.require(:retweet).permit(:group_id, :url, :start_at, :interval, :frequency)
    end
end