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
    # newビューにて送ったformをuser_paramsで受け取り、ユーザーオブジェクトを生成、@userに代入。悪意あるユーザー対策Strong Parametersを引数に必要な情報のみに絞る。
    if @user.save  # 保存の成功をここで扱う。
      log_in(@user) # sessions_helperのlog_inメソッドを実行。session[:user_id] = @user.id
       flash[:success] = "Welcome to the Sample App!" # flashの:successシンボルに成功時のメッセージを代入
      redirect_to @user  # redirect_to user_url(@user)の略。redirect_to("/users/#{@user.id}")と等価。/users/idへ飛ばす(https://qiita.com/Kawanji01/items/96fff507ed2f75403ecb)を参考
    else
      render 'users/new'  #views/users/newへアクセスする
    end
  end

  def edit
    @user = User.find(params[:id])  #Usersリソースが提供するユーザー編集ページの正しいURLが/users/1/editとなっている。params[:id]変数でuser.idを取り出す。
  end

  def update
    @user = User.find(params[:id]) #Usersリソースが提供するユーザー編集ページの正しいURLが/users/1/editとなっている。params[:id]変数でuser.idを取り出
    if @user.update_attributes(user_params) # editビューにて送ったformをuser_paramsで受け取り、ユーザーオブジェクトを生成、@userに代入。悪意あるユーザー対策Strong Parametersを引数にし必要な情報のみに絞る。
     # 更新に成功した場合を扱う。
     flash[:success] = "プロフィール更新完了"
     redirect_to @user #user_path(@user)→'/users/@user.id'へリダイレクト
    else
      render 'edit' #views/users/editへアクセスする
    end
  end

  # Strong Parameters
  private

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
  # 特定の属性:userオブジェクトの:name,:email,:password,:password_confirmationを許可し、それ以外は受け付けない設定。
end
