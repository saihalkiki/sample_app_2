require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User",email: "user@example")
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
   assert_not @user.valid?
 end

 test "email should not be too long" do
   @user.email = "a" * 244 + "@example.com"
   assert_not @user.valid?
 end

end
