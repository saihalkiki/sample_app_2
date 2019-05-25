class User < ApplicationRecord
  before_save { self.email = email.downcase }
  # before_save { email.downcase! }
  # いくつかのデータベースのアダプタが、常に大文字小文字を区別するインデックスを使っているとは限らない問題への対処

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, length: { maximum: 255},
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false})
            # validates(format: { with: OOOOOOOOOO }) → メールアドレスのフォーマットを検証
            # validates(uniqueness: ture) → 一意性の検証オプション
            # case_sensitive: → true:大文字小文字を区別する false:大文字小文字を区別しない

  has_secure_password
  # Userモデルにpassword_digest属性を追加し、Gemfileにbcryptを追加したことで、Userモデル内でhas_secure_passwordが使えるようになる

  validates :password, presence: true, length: { in: 6..72 }
  # 略前→validates( :password, :presence => true, :length => {:minimum => 6})

end
