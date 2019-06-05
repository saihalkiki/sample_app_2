class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, default: false
    # default: falseという引数は、デフォルトでは管理者になれないということを示す
  end
end
