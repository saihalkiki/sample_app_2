class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper  #SessionsHelperを全コントローラに適用

  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
