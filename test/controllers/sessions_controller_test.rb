require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do  # newアクション(/login)に対してのテスト
    get login_path  # /loginにgetリクエストを送る
    assert_response :success  # レスポンスのHTTPステータスコードが200と一致したらtrue、異なればfalse
  end

end
