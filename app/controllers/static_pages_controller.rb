class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      # サンプルアプリケーションにフィード機能を導入するため、ログインユーザーのフィード用にインスタンス変数@feed_itemsを追加
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
