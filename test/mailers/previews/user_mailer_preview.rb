# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  # app/mailers/user_mailer.rbのaccount_activationの引数には有効なUserオブジェクトを渡す必要があるため、user変数が開発用データベースの最初のユーザーになるように定義して、それをUserMailer.account_activationの引数として渡します
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

end
