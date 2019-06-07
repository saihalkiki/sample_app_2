class UserMailer < ApplicationMailer

# アカウント有効化リンクをメール送信
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

# パスワード再設定のリンクをメールで送信
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

end
