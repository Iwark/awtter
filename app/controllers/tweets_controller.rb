class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  # 一覧
  def index
    @tweets = Tweet.all
  end

  def show
  end

  # 新規
  def new
    @tweet = Tweet.new
  end

  # 編集
  def edit
  end

  # 作成
  def create
    @tweet = Tweet.new(tweet_params)
    if @tweet.save
      redirect_to tweets_url, notice: 'tweet was successfully created.'
    else
      render :new
    end
  end

  # 更新
  def update
    if @tweet.update(tweet_params)
      redirect_to tweets_url, notice: 'tweet was successfully updated.'
    else
      render :edit
    end
  end

  # 削除
  def destroy
    @tweet.destroy
    redirect_to tweets_url, notice: 'tweet was successfully destroyed.'
  end

  private
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    def tweet_params
      params.require(:tweet).permit(:account_id, :text, :tweet_id)
    end
end