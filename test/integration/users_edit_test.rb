require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user) #before_actionでloginしてない場合は、editアクションができないように指定しているため、最初にログインをする
    get edit_user_path(@user) # GETリクエスト '/users/@user.id/edit'
    assert_template 'users/edit'  # views/users/editが表示されたら、trueを返す
    patch user_path(@user), params: { user: { name:  "",  email: "foo@invalid",  password: "foo", password_confirmation: "bar" } } # パラメーター代入し、PATCHリクエストの'/users/@user.id'
    assert_template 'users/edit' # views/users/editが表示されたら、trueを返す
    assert_select "div.alert", "The form contains 4 errors."
  end

  test "successful edit" do
    log_in_as(@user) #before_actionでloginしてない場合は、editアクションができないように指定しているため、最初にログインをする
    get edit_user_path(@user)  # GETリクエスト '/users/@user.id/edit'
    assert_template 'users/edit' # views/users/editが表示されたら、trueを返す
    name  = "Foo Bar"  #nameフォームにFoo Barを入力
    email = "foo@bar.com"  #emailフォームにFoo Bar
    patch user_path(@user), params: { user: { name:  name, email: email,  password: "", password_confirmation: "" } } # パラメーター代入し、PATCHリクエストの'/users/@user.id'
    assert_not flash.empty? #flashが表示されればtrue
    assert_redirected_to @user # '/users/@user.id'に移動できたらtrue
    @user.reload # user.reloadを使ってDBから最新のユーザー情報を読み込み直して、正しく更新されたかどうか確認
    assert_equal name,  @user.name # DB内@user.nameがnameになっていればtrue
    assert_equal email, @user.email # DB内@user.emailがemailになっていればtrue
  end

  test "successful edit with friendly forwarding" do  #フレンドリーフォワーディングのテスト
  # ①編集ページにアクセス
  # ②ログイン
  # ③編集ページにリダイレクトされているかどうかチェックする
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

end
