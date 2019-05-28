class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) #find_byメソッドを使い、UserデータベースからログインページのデータとマッチするUserオブジェクトを取得し、userに代入。
    if user && user.authenticate(param[:session][:password])
      # userオブジェクトとモデルに「has_secure_password」メソッドを追加したことで使える「authenticate」メソッド(引数の文字列がパスワードと一致するとUserオブジェクト)で帰ってきたuserオブジェクトを比較する。
    else
      flash.now[:denger] = 'メールアドレスかパスワードのどちらかが間違っています。'
      render 'new' # sessions/newビューの出力
    end
  end

  def destroy

  end
end
