class RelationshipsController < ApplicationController
# リレーションシップのアクセス制御
  before_action :logged_in_user

# フォームから送信されたパラメータを使って、followed_idに対応するユーザーを見つけ,その後、見つけてきたユーザーに対して適切にfollow/unfollowメソッドを使う
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # Ajaxリクエストに対応
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

# フォームから送信されたパラメータを使って、followed_idに対応するユーザーを見つけ,その後、見つけてきたユーザーに対して適切にfollow/unfollowメソッドを使う
def destroy
  @user = Relationship.find(params[:id]).followed
  current_user.unfollow(@user)
  # Ajaxリクエストに対応
  respond_to do |format|
    format.html { redirect_to @user }
    format.js
  end
end
end
