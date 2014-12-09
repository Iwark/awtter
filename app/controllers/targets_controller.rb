class TargetsController < ApplicationController
  before_action :set_target, only: [:show, :edit, :update, :destroy]

  # 一覧
  def index
    @targets = Target.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  # 新規
  def new
    @target = Target.new
  end

  # 編集
  def edit
  end

  # 作成
  def create
    @target = Target.new(target_params)
    @target.status = "following"
    if @target.save
      redirect_to targets_url, notice: 'target was successfully created.'
    else
      render :new
    end
  end

  # 更新
  def update
    if @target.update(target_params)
      redirect_to targets_url, notice: 'target was successfully updated.'
    else
      render :edit
    end
  end

  # 削除
  def destroy
    @target.destroy
    redirect_to targets_url, notice: 'target was successfully destroyed.'
  end

  private
    def set_target
      @target = Target.find(params[:id])
    end

    def target_params
      params.require(:target).permit(:name, :description)
    end
end