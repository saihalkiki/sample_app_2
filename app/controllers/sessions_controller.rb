class SessionsController < ApplicationController
  # logger.info("--------saito costom------------")
  # logger.info(cookies['remember_token'])
  # logger.info("--------saito costom------------")

  def new #(GET login_path)
    # debugger
  end

  def create  #(POST login_path)
    @user = User.find_by(email: params[:session][:email].downcase) #find_byメソッドを使い、UserデータベースからログインページのデータとマッチするUserオブジェクトを取得し、userに代入。
    if @user && @user.authenticate(params[:session][:password])
      # userオブジェクトとモデルに「has_secure_password」メソッドを追加したことで使える「authenticate」メソッド(引数の文字列がパスワードと一致するとUserオブジェクト)で帰ってきたuserオブジェクトを比較する。

      # user.activated?がtrueの場合にのみログインを許可し、そうでない場合はルートURLにリダイレクトしてwarningで警告を表示
      if @user.activated?
        log_in @user # sessions_helperのlog_inメソッドを実行。session[:user_id] = user.id
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message  = "アカウントは有効ではありません "
        message += "メールで送られたURLから有効化してください"
        flash[:warning] = message
        redirect_to root_url
      end
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
