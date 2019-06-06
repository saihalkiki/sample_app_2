require 'test_helper'

# assert_matchという非常に強力なメソッドが使われています。これを使えば、正規表現で文字列をテストできます。
# assert_match 'foo', 'foobar'       true
# assert_match 'baz', 'foobar'       false
# assert_match /\w+/, 'foobar'       true
# assert_match /\w+/, '$#!*+@'       false

# CGI.escape(user.email)メソッドを使うと、テスト用のユーザーのメールアドレスをエスケープすることもできます

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
    # assert_match user.email, mail.body.encoded　→　エラーがでる。
    # Expected /michael@example\.com/ to match # encoding: US-ASCII "\r\n…
  end
  # fixtureユーザーに有効化トークンを追加している
  # テストがパスするには、config/environments/test.rb内のドメイン名を正しく設定する必要があります→なぜ？次のエラーが解消できるのか？
  # ActionView::Template::Error:         ActionView::Template::Error: Missing host to link to! Please provide the :host parameter, set default_url_options[:host], or set :only_path to true
            # app/views/user_mailer/account_activation.html.erb:9:in `_app_views_user_mailer_account_activation_html_erb__2257556764507285820_70294306634960'
            # app/mailers/user_mailer.rb:5:in `account_activation'
            # test/mailers/user_mailer_test.rb:17:in `block in <class:UserMailerTest>'
end
