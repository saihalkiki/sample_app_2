require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do  # 新規登録が失敗（フォーム送信が）した時用のテスト
    get signup_path  # ユーザー登録ページにアクセス
    assert_no_difference 'User.count' do # User.countでユーザー数が変わっていなければ（ユーザー生成失敗していれば）true,変わっていればfalse
      post signup_path, params: { user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" } }  # signup_pathからusers_pathに対してpostリクエスト送信(post /usersへ)しcreateアクションを確認。User.newに送信するデータをparamsでuserハッシュとその下のハッシュで値をまとめている
      end
    assert_template "users/new","登録失敗時にviews/users/newへ飛んでいません"
    assert_select   'div#error_explanation' # divタグの中のid error_explanationをが描画されていれば成功
    assert_select   'div.field_with_errors' # divタグの中のclass field_with_errorsが描画されていれば成功
    assert_select   'form[action="/signup"]'   # formタグの中に`/signup`があれば成功
  end

end
