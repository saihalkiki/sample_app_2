require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar")
    # has_secure_passwordメソッド追加により、２つのペアの仮想的な属性 (passwordとpassword_confirmation) が使えるようになる。
  end

  test "should be vaild" do
    assert @user.valid?, "バリデーションに引っかかってfalseを返してます"
  end

 test "name should be present(名前が空白で入力できてしまいます)" do
   @user.name = "  "
   assert_not @user.valid?, "バリデーションに引っかかってfalseを返してます"
 end

 test "email should be present(メールが空白で入力できてしまいます)" do
   @user.email = "  "
   assert_not @user.valid?, "バリデーションに引っかかってfalseを返してます"
 end

 test "name should not be too long(名前は長すぎてはいけません)" do
   @user.name = "a" * 51
   assert_not @user.valid?, "名前が51文字以上登録されております"
 end

 test "email should not be too long" do
   @user.email = "a" * 244 + "@example.com"
   assert_not @user.valid?, "メールが256文字以上入ります"
 end

 test "email validation should reject invalid addresses" do
   invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com]
   invalid_addresses.each do |invalid_address|
     @user.email = invalid_address
     assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
   end
 end

  test "email addresses should be unique(大文字小文字を区別しない一意性のテスト)" do
    duplicate_user = @user.dup        # userを複製(duplicate_user)→複製しないとid情報がかぶるため、上書き扱いになる
    duplicate_user.email =@user.email.upcase  # 大小文字の検証のため、duplicate_userのアドレスを大文字にする
    @user.save                        # userを保存
    assert_not duplicate_user.valid?  # userとduplicate_userが一緒であれば無効かどうか検証
  end

  test "email addresses should be saved as lower-case(メールアドレスの小文字化に対するテスト)" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (password空白に対するテスト)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid? ,"空白で保存できてしまいます"
  end

  test "password should have a minimum length(passwordの長さ6文字以上のテスト)" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid? , "5文字で保存できてしまいます"
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')  # @userのユーザーの記憶ダイジェストと引数で受け取った値が同一ならfalse、異なるならtrueを返す
  end

end
