require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do # ログインしてない時、editページはひらけないテスト
    get edit_user_path(@user)  # GETリクエスト '/users/@user.id/edit'
    assert_not flash.empty?  # flashが表示されたらtrue
    assert_redirected_to login_url  # '/login'のURLへ飛べたらtrue
  end

  test "should redirect update when not logged in" do  #ログインしてない時、更新データは遅れないテスト
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    # PATCHリクエストで保存ユーザーの名前とメルアドを引数に取り送信(更新)
    assert_not flash.empty?  # flashが表示されたらtrue
    assert_redirected_to login_url  # '/login'のURLへ飛べたらtrue
  end

  test "should not allow the admin attribute to be edited via the web" do # admin属性の変更が禁止されていることをテスト
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              'password',
                                            password_confirmation: 'password',
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "should redirect edit when logged in as wrong user" do  # @other_userで編集できないようにするテスト
    log_in_as(@other_user)  # @other_userでログインする
    get edit_user_path(@user)  # @userの編集ページを取得
    assert flash.empty?   # flashが空ならtrue
    assert_redirected_to root_url  # '/'へ移動できればtrue
  end

  test "should redirect update when logged in as wrong user" do  # @other_userで編集できないようにするテスト
    log_in_as(@other_user)  # @other_userでログインする
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?  # flashが空ならtrue
    assert_redirected_to root_url  # '/'へ移動できればtrue
  end

  test "should redirect destroy when not logged in" do # DELETEリクエストを発行してdestroyアクションを直接動作、ログインしていないユーザーであれば、ログイン画面にリダイレクトされる
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do # DELETEリクエストを発行してdestroyアクションを直接動作、ログイン済みではあっても管理者でなければ、ホーム画面にリダイレクトされる
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

end
