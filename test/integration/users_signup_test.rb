require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do  # 新規登録が失敗（フォーム送信が）した時用のテスト
    get signup_path  # ユーザー登録ページにアクセス
    assert_no_difference 'User.count' do # User.countでユーザー数が変わっていなければ（ユーザー生成失敗していれば）true,変わっていればfalse
      post signup_path, params: { user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" } }  # signup_pathからusers_pathに対してpostリクエスト送信(post /usersへ)しcreateアクションを確認。User.newに送信するデータをparamsでuserハッシュとその下のハッシュで値をまとめている
      end
    assert_template "users/new" #登録失敗時にviews/users/newへ飛んでいません
    assert_select   'div#error_explanation' # divタグの中のid error_explanationをが描画されていれば成功
    assert_select   'div.field_with_errors' # divタグの中のclass field_with_errorsが描画されていれば成功
    assert_select   'form[action="/signup"]'   # formタグの中に`/signup`があれば成功
  end

  test "valid signup information with account activation" do # 新規登録が成功（フォーム送信）した&&アカウント有効化(メール承認)のテスト
      get signup_path # signup_path(/signup)ユーザー登録ページにアクセス
      assert_difference 'User.count', 1 do # User.countでユーザー数をカウント、1とし、ユーザー数が変わったらtrue、変わってなければfalse
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
  # signup_path(/signup)からusers_path(/users)へparamsハッシュのuserハッシュの値を送れるか検証
      end
      assert_equal 1, ActionMailer::Base.deliveries.size
      # 配信されたメッセージがきっかり1つであるかどうかを確認.
      # 配列deliveriesは変数なので、setupメソッドでこれを初期化しておかないと、並行して行われる他のテストでメールが配信されたときにエラーが発生してしまう
      user = assigns(:user)
      # assignsメソッドを使うと、例えば、Usersコントローラのcreateアクションでは@userというインスタンス変数が定義されており、assigns(:user)と書くとこのインスタンス変数にアクセスできるようになる
      assert_not user.activated?
      # 有効化していない状態でログインしてみる
      log_in_as(user)
      assert_not is_logged_in?
      # 有効化トークンが不正な場合
      get edit_account_activation_path("invalid token", email: user.email)
      assert_not is_logged_in?
      # トークンは正しいがメールアドレスが無効な場合
      get edit_account_activation_path(user.activation_token, email: 'wrong')
      assert_not is_logged_in?
      # 有効化トークンが正しい場合
      get edit_account_activation_path(user.activation_token, email: user.email)
      assert user.reload.activated?
      follow_redirect! # 直前（POSTリクエストを送信した）の結果を見て、指定されたリダイレクト先に移動する
      assert_template 'users/show'  # users/showが描画されているか確認
      assert_not flash.empty? # flashが空ならfalse,空じゃなければtrue
      assert is_logged_in?  # 新規登録時にセッションが空ならfalse、空じゃない（ログインしていれば)true
    end

end
