class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  # correct_userフィルター内でfindメソッドを呼び出すことで、現在のユーザーが削除対象のマイクロポストを保有しているかどうかを確認

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

# マイクロポストの削除アクション
def destroy
  @micropost.destroy
  flash[:success] = "Micropost deleted"
  redirect_to request.referrer || root_url
  # request.referrerというメソッドを使っている。フレンドリーフォワーディングのrequest.url変数 (10.2.3) と似ていて、一つ前のURLを返します (今回の場合、Homeページになります)マイクロポストがHomeページから削除された場合でもプロフィールページから削除された場合でも、request.referrerを使うことでDELETEリクエストが発行されたページに戻すことができるので、非常に便利。元に戻すURLが見つからなかった場合でも (例えばテストではnilが返ってくることもあります)、リスト 13.52の||演算子でroot_urlをデフォルトに設定しているため、大丈夫。
end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
      # :picture=>CarrierWave(画像アップローダー)をWebから更新できる許可リストにpicture属性を追加しましょう
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
