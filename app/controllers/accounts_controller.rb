class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # 一覧
  def index
    @accounts = Account.all
  end

  def show
  end

  # 新規
  def new
    @account = Account.new
  end

  # 編集
  def edit
  end

  # 作成
  def create
    @account = Account.new(account_params)
    if @account.save
      redirect_to root_url, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  # 更新
  def update
    if @account.update(account_params)
      redirect_to root_url, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  # 削除
  def destroy
    @account.destroy
    redirect_to root_url, notice: 'Account was successfully destroyed.'
  end

  private
    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :api_key, :api_secret, :access_token, :access_token_secret, :target, :description, :group_id, :auto_tweet, :auto_retweet, :tag_list)
    end
end