require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

    # 永続的セッションのテスト

    def setup
      @user = users(:michael) # fixtureにあるmichaelをユーザーとして定義
      remember(@user) # ユーザーをrememberの引数として受け取って記憶する
    end

    test"current_user returns right user when sessions is nil" do
      assert_equal @user, current_user # current_userとmichaelが同じかどうかテスト
      # assert_equalの引数は「期待する値, 実際の値」の順序で書く点に注意
      assert is_logged_in? # session[:user_id]が空ならfalse、空じゃない（ログインしていれば)true
    end

    test "current_user returns nil when remember digest is wrong" do
      @user.update_attribute(:remember_digest, User.digest(User.new_token))   # @userのremember_digestが、ハッシュ化したremember_tokenをdigest化した値と同じなら、remember_digestを更新する
      assert_nil current_user # current_userがnilならtrue(@userが更新できない場合、current_userがnilになるかどうか検証)
    end
end
