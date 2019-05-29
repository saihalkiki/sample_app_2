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
    # newビューにて送ったformをuser_paramsで受け取り、ユーザーオブジェクトを生成、@userに代入。悪意あるユーザー対策Strong Parametersを引数にする
    if @user.save  # 保存の成功をここで扱う。
      log_in @user # sessions_helperのlog_inメソッドの引数として@user(ユーザーオブジェクト)を渡す。「session[:user_id] = user.id」。
      flash[:success] = "ようこそ！HARUKAのサイトへ！" # flashの:successシンボルに成功時のメッセージを代入
      redirect_to @user  # redirect_to user_url(@user)の略。redirect_to("/users/#{@user.id}")と等価。/users/idへ飛ばす(https://qiita.com/Kawanji01/items/96fff507ed2f75403ecb)を参考
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
