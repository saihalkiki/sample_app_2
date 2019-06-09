require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do  # 正常な状態かどうかをテスト (sanity check)
    assert @micropost.valid?
  end

  test "user id should be present" do  # user_idが存在しているかどうか (nilではないか) をテスト
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do #  データベース上の最初のマイクロポストが、fixture内のマイクロポスト (most_recent) と同じであるか検証する
    assert_equal microposts(:most_recent), Micropost.first
  end

end
