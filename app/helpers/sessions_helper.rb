module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id #ユーザーidをsessionのuser_idに代入（ログインidの保持）。sessionメソッドで作成した一時cookiesは自動的に暗号化され、コードは保護される。
  end

  # 現在ログイン中のユーザーを返す(いる場合)
  def current_user
    if session[:user_id]  # ログインユーザーがいればtrue処理
      @current_user ||= User.find_by(id: session[:user_id]) # ログインユーザーがいればそのまま、いなければsessionユーザーidと同じidを持つユーザーをDBから探して@current_user（現在のログインユーザー）に代入
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?  # current_user(ログインユーザー)がnil以外ならtrue、nilなzらfalseを返す。「!」は否定演算子。
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
