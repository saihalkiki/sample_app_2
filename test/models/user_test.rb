require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User",email: "user@example")
  end

  test "should be vaild" do
    assert @user.valid?, "バリデーションに引っかかってfalseを返してます"
  end

end
