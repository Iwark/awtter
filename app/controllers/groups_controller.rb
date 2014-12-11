class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # 一覧
  def index
    @groups = Group.all.includes([accounts: [:target, :followed_users]])
    @followers_sum = 0
    @groups.each do |group|
      group.accounts.each do |account|
        @followers_sum += account.follower_num
      end
    end
    @group = Group.new
    @account = Account.new
  end

  def show
  end

  # 新規
  def new
    @group = Group.new
  end

  # 編集
  def edit
  end

  # 作成
  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to root_url, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  # 更新
  def update
    if @group.update(group_params)
      redirect_to root_url, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  # 削除
  def destroy
    @group.destroy
    redirect_to root_url, notice: 'Group was successfully destroyed.'
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :tag_list)
    end
end