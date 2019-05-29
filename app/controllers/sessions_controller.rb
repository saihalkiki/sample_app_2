class SessionsController < ApplicationController
  def new
  end

  def create  #ログインの処理
    user = User.find_by(email: params[:session][:email].downcase) #find_byメソッドを使い、UserデータベースからログインページのデータとマッチするUserオブジェクトを取得し、userに代入。
    if user && user.authenticate(params[:session][:password])
      # userオブジェクトとモデルに「has_secure_password」メソッドを追加したことで使える「authenticate」メソッド(引数の文字列がパスワードと一致するとUserオブジェクト)で帰ってきたuserオブジェクトを比較する。
      log_in(user) # sessions_helperのlog_inメソッドを実行「session[:user_id] = user.id」。sessionメソッドで作成した一時cookiesは自動的に暗号化されコードは保護される。
      redirect_to user # redirect_to user_url(user)の略。redirect_to("/users/#{user.id}")と等価。つまり/users/idへ飛ばす。
    else
      flash.now[:denger] = 'メールアドレスかパスワードのどちらかが間違っています。'
      render 'new' # sessions/newビューの出力
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
