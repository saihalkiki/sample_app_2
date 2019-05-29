class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper  #SessionsHelperを全コントローラに適用

end
