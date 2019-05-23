class User < ApplicationRecord
  validates(:name, presence: true, length: { maximum: 50 })

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, length: { maximum: 255},
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false})
            # validates(format: { with: OOOOOOOOOO }) → メールアドレスのフォーマットを検証
            # validates(uniqueness: ture) → 一意性の検証オプション
            # case_sensitive: → true:大文字小文字を区別する false:大文字小文字を区別しない

end
