class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]    # (1) パスワード再設定の有効期限が切れていないかの対応

  def new

  end

# フォームから送信を行なった後、メールアドレスをキーとしてユーザーをデータベースから見つけ、パスワード再設定用トークンと送信時のタイムスタンプでデータベースの属性を更新する
  def create # パスワードの再設定
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit

  end

  def update
    if params[:user][:password].empty?  # (3) 新しいパスワードが空文字列になっていないかへの対応
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)  # (4) 新しいパスワードが正しければ、更新するへの対応
      log_in @user
      @user.update_attribute(:reset_digest, nil)  #パスワード再設定が成功したらダイジェストをnilに
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'  # (2) 無効なパスワードであれば失敗させる
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # beforeフィルタ

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 有効なユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # パスワード再設定のトークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?  # パスワード再設定の期限が切れている場合はtrueを返す

        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
