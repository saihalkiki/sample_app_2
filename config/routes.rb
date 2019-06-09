Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]

  # HTTPﾘｸｴｽﾄ  URL        ｱｸｼｮﾝ   名前付きﾙｰﾄ
  # GET	    /users	      index	  users_path          users_url
  # すべてのユーザーを一覧するページ

  # GET	    /users/1	    show	  user_path(user)     user_url(user)
  # 特定のユーザーを表示するページ

  # GET	    /users/new	  new	    new_user_path       new_user_url
  # ユーザーを新規作成するページ (ユーザー登録)

  # POST	  /users	      create	users_path          users_url
  # ユーザーを新規作成するアクション

  # GET	    /users/1/edit	edit	 edit_user_path(user) edit_user_url(user)
  # id=1のユーザーを編集するページ

  # PATCH	  /users/1	    update	user_path(user)     user_url(user)
  # ユーザーを更新するアクション

  # DELETE	/users/1	    destroy	user_path(user)     user_url(user)
  # ユーザーを削除するアクション


# resources :account_activations, only: [:edit]

  # HTTPﾘｸｴｽﾄ : GET	 URL : /account_activation/<token>/edit	 ｱｸｼｮﾝ : edit  名前付きﾙｰﾄ : edit_account_activation_url(token)


# resources :password_resets,     only: [:new, :create, :edit, :update]

# GET	  /password_resets/new	        new	    new_password_reset_path
# POST	/password_resets	            create	password_resets_path
# GET	  /password_resets/<token>/edit	edit	  edit_password_reset_url(token)
# PATCH	/password_resets/<token>	    update	password_reset_url(token)

# resources :microposts,          only: [:create, :destroy]
# POST	  /microposts	  create	microposts_path
# DELETE	/microposts/1	destroy	micropost_path(micropost)



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
