require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  test "login with invalid information" do    # ログインフォームで空のデータを送り、エラーのフラッシュメッセージが描画され、別ページに飛んでflashが空であるかテスト
    get login_path    # getリクエスト '/login'
    assert_template 'sessions/new'  #views/sessions/newが表示されたら、trueを返す
    post login_path,params: { session: { email: "",password: ""}}   #無効なデータ(paramsハッシュ)をPostリクエスト'/login'を送信
    assert_template 'sessions/new'  #sessions/new（ログインフォームのビュー）が描画されていればtrue
    assert_not flash.empty?   #flasが表示されていればtrue
    get root_path   #get '/'を取得
    assert flash.empty?   #flash表示が消えていればtrue
  end

end
