class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    # debugger
  end

  def new
    @user = User.new
    # debugger
  end

  def create
    @user = User.new(user_params)
    # 悪意あるユーザー対策Strong Parametersを引数にする
    if @user.save
      # 保存の成功をここで扱う。
    else
      render 'users/new'
    end
  end

  # Strong Parameters
  private

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
  # 特定の属性:userオブジェクトの:name,:email,:password,:password_confirmationを許可し、それ以外は受け付けない設定。
end
