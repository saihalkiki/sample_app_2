module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id #ユーザーidをsessionのuser_idに代入（ログインidの保持）。sessionメソッドで作成した一時cookiesは自動的に暗号化され、コードは保護される。
  end

  # ユーザーのセッションを永続的にする
  def remember(user)  # rememberメソッドにuser(ログイン時にユーザーが送ったメールとパスと同一の、DBにいるユーザー)を引数として渡す
    user.remember  # model/User.classのrememberメソッドを使い、ログイン時のユーザーと同一のDBのユーザーに、remember_tokenを生成してremember_digestにハッシュ化したハッシュ値を持たせて保存
    cookies.permanent.signed[:user_id] = user.id  # ログイン時のユーザーidを、有効期限(20年)と署名付きの暗号化したユーザーidとしてcookiesに保存
    cookies.permanent[:remember_token] = user.remember_token  # ログイン時のremember_tokenを、有効期限（20年）を設定して新たなremember_tokenに保存。Userモデルにて、ログインユーザーと同一ならtrueを返す
  end

  # remember_token_cookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id]) # user_idにsession[:user_id]を代入した結果、user_idが存在すればtrue
      @current_user ||= User.find_by(id: user_id)   # @current_user(現在のログインユーザー)が存在すればそのまま、なければuser_id(session[:user_id])と同じidを持つユーザーをDBから探して@current_userに代入
    elsif (user_id = cookies.signed[:user_id]) # user_idに署名付きcookieを代入した結果、user_idに著名付きcookiesが存在すればtrue
      # raise  # テストがパスすれば、この部分がテストされていないことがわかる
      user = User.find_by(id: user_id) # user_id(著名な付きcookie)と同じユーザーidをもつユーザーをDBから探し、userに代入
      if user && user.authenticated?(cookies[:remember_token]) # DBのユーザーがいるかつ、受け取ったremember_tokenをハッシュ化した記憶ダイジェストを持つユーザーがいる場合処理を行う
        log_in(user) # session[:user_id]にuserのIDを代入
        @current_user = user  # @current_userにuser(User.find_by(id: user_id))を代入
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?  # current_user(ログインユーザー)がnil以外ならtrue、nilなzらfalseを返す。「!」は否定演算子。
  end

  #永続的セッションを破棄する
  def forget(user)
    user.forget # 引数に対してforgetメソッドを呼び出し、DBにあるremember_digestをnilにする
    cookies.delete(:user_id)  # cookiesのuser_idを削除
    cookies.delete(:remember_token) # cookiesのremeber_tokenを削除
  end

  # ユーザーをログアウトする
  def log_out
    forget(current_user)  # forgetメソッドを呼び出し、引数@current_userのDBにあるremember_digestをnilにして、cookies[:user_id]とcookies[:remeber_token]を消去する
    session.delete(:user_id) # session[:user_id]を削除する
    @current_user = nil # @current_userをnilする
  end

end
