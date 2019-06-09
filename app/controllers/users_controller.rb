class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # onlyオプション(ハッシュ)で指定したeditとupdateアクションだけに「logged_in_user」メソッドを適用
  before_action :correct_user,   only: [:edit, :update]  # onlyオプション(ハッシュ)で指定したeditとupdateアクションだけに「correct_user」メソッドを適用
  before_action :admin_user,     only: :destroy
  # eforeフィルターを使ってdestroyアクションへのアクセスを制御

  def index # 全てのユーザーを表示するページ
    @users = User.where(activated: true).paginate(page: params[:page])
    # @users = User.all
    # @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated? # activatedがfalseならルートURLヘリダイレクト
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
      # log_in(@user) # sessions_helperのlog_inメソッドを実行。session[:user_id] = @user.id
      @user.send_activation_email  # アカウント有効化メールの送信
      # ユーザーは以前のようにログイン(log_in(@user))しないようにした。

       # flash[:success] = "Welcome to the Sample App!" # flashの:successシンボルに成功時のメッセージを代入
      flash[:info] = "メールを確認してアカウントを有効化してください。"

      # redirect_to @user  # redirect_to user_url(@user)の略。redirect_to("/users/#{@user.id}")と等価。/users/idへ飛ばす(https://qiita.com/Kawanji01/items/96fff507ed2f75403ecb)を参考
      redirect_to root_url

    else
      render 'users/new'  #views/users/newへアクセスする
    end
  end

  def edit
    @user = User.find(params[:id])  #Usersリソースが提供するユーザー編集ページの正しいURLが/users/1/editとなっている。params[:id]変数でuser.idを取り出す。
  end

  def update
    # @user = User.find(params[:id]) #Usersリソースが提供するユーザー編集ページの正しいURLが/users/1/editとなっている。params[:id]変数でuser.idを取り出
    if @user.update_attributes(user_params) # editビューにて送ったformをuser_paramsで受け取り、ユーザーオブジェクトを生成、@userに代入。悪意あるユーザー対策Strong Parametersを引数にし必要な情報のみに絞る。
     # 更新に成功した場合を扱う。
     flash[:success] = "プロフィール更新完了"
     redirect_to @user #user_path(@user)→'/users/@user.id'へリダイレクト
    else
      render 'edit' #views/users/editへアクセスする
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  # Strong Parameters
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
    # 特定の属性:userオブジェクトの:name,:email,:password,:password_confirmationを許可し、それ以外は受け付けない設定。

    # /beforeアクション/

    # def logged_in_user  →  

    def correct_user  # 正しいユーザーかどうか確認(他のユーザーがいじれないようにするもの)
      @user = User.find(params[:id])  # URLのidの値と同じユーザーを@userに代入
      redirect_to(root_url) unless current_user?(@user)  # @userとcurrent_userを比較して、違えばroot_urlへリダイレクト
    end

    # 管理者かどうか確認
    def admin_user  # beforeフィルター用のadmin_userフィルター
      redirect_to(root_url) unless current_user.admin?
    end

  end
