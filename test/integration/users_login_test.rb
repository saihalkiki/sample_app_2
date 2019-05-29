require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do    # ログインフォームで空のデータを送り、エラーのフラッシュメッセージが描画され、別ページに飛んでflashが空であるかテスト
    get login_path    # getリクエスト '/login'
    assert_template 'sessions/new'  #views/sessions/newが表示されたら、trueを返す
    post login_path,params: { session: { email: "",password: ""}}   #無効なデータ(paramsハッシュ)をPostリクエスト'/login'を送信
    assert_template 'sessions/new'  #sessions/new（ログインフォームのビュー）が描画されていればtrue
    assert_not flash.empty?   #flasが表示されていればtrue
    get root_path   #get '/'を取得
    assert flash.empty?   #flash表示が消えていればtrue
  end

  test "login with valid information followed by logout" do  # ログインとログアウトのテスト
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password' } } #POSTリクエスト URL/loginを送信し、ルーティングされたcreateアクションを動作させる。parameterはfixtures/users.ymlの通り送信し、ログインする。
    assert is_logged_in? # セッションが空ならfalse、空じゃない（ログインしていれば)true
    assert_redirected_to @user
    # rediret先が@user(ユーザーページ)になっているか確認
    follow_redirect! # 指定されたリダイレクト先に移動するメソッド
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0 # リンク login_path(/login)が存在しなければtrue(count: 0というオプションで一致するリンクが0かどうかを確認している)
    assert_select "a[href=?]", logout_path # リンク logout_path(/logout)が存在すればtrue
    assert_select "a[href=?]", user_path(@user) # リンク user_path(@user)→(/users/@user.id)が存在すればtrue
    delete logout_path #DELETEリクエスト URL(/logout)を送信
    assert_not is_logged_in? # セッションが空ならtrue、空じゃない（ログインしていれば)false
    assert_redirected_to root_url #rediret先がroot_url('/')になっているか
    follow_redirect! # リダイレクト先に移動する
    assert_select "a[href=?]", login_path # リンク login_path('/login')が存在すればtrue
    assert_select "a[href=?]", logout_path,      count: 0 #logout_path('/logout')が存在しなければtrue(count: 0というオプションで一致するリンクが0かどうかを確認している)
    assert_select "a[href=?]", user_path(@user), count: 0 #lリンク user_path(@user)→(/users/@user.id)が存在しなければtrue(count: 0というオプションで一致するリンクが0かどうかを確認している)
  end

end
