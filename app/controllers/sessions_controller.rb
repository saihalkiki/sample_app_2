class SessionsController < ApplicationController
  def new #(GET login_path)
  end

  def create  #(POST login_path)
    @user = User.find_by(email: params[:session][:email].downcase) #find_byメソッドを使い、UserデータベースからログインページのデータとマッチするUserオブジェクトを取得し、userに代入。
    if @user && @user.authenticate(params[:session][:password])
      # userオブジェクトとモデルに「has_secure_password」メソッドを追加したことで使える「authenticate」メソッド(引数の文字列がパスワードと一致するとUserオブジェクト)で帰ってきたuserオブジェクトを比較する。
      log_in @user # sessions_helperのlog_inメソッドを実行。session[:user_id] = user.id
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # 以下を三項演算子 (ternary operator)を使い、一行で表したもの
      # if params[:session][:remember_me] == '1'
      #   remember(user)
      # else
      #   forget(user)
      # end
      redirect_to @user # redirect_to user_url(user)の略。redirect_to("/users/#{user.id}")と等価。つまり/users/idへ飛ばす。
    else
      flash.now[:danger] = 'メールアドレスかパスワードのどちらかが間違っています。'
      render 'new' # sessions/newビューの出力
    end
  end

  def destroy #(DELETE logout_path)
    log_out if logged_in?  #sessionヘルパーメソッドのlogged_in?(!current_user.nil?)がtrueの場合に限って、sessionヘルパーメソッドのlog_outメソッドを呼び出す。
    redirect_to root_url  #'/'(home)へ移動
  end

end
