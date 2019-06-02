class User < ApplicationRecord
  attr_accessor :remember_token #remember_token属性を作成
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

  validates :password, presence: true, length: { minimum: 6 }
  # 略前→validates( :password, :presence => true, :length => {:minimum => 6})
  # Module ActiveModel::SecurePassword に72bytesを超える長さは無視すると記載があったため、72bytesに制限

  class << self
  #テストのfixture用に、password_digestの文字列をハッシュ化して、ハッシュ値として返す
    def digest(string)
    # def self.digest(string) → def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def new_token # Userクラスにnew_tokenを渡したクラスメソッドを作成
    # self.new_token → def User.new_tokenの略
      SecureRandom.urlsafe_base64 # SecureRandomモジュールにbase64でランダムな22bytesの文字列を生成
    end
  end
    # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token  # remember_token属性にランダムなトークンを代入
    update_attribute(:remember_digest, User.digest(remember_token)) # DBのremember_digest属性にremember_tokenをBcryptでハッシュ化して更新
  end

  # 引数として受け取った値をrememberに代入して暗号化（remember_digest）し、DBにいるユーザーのremember_digestと比較、同一ならtrue・違えばfelseを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?  # 記憶ダイジェストがnilの場合、falseを戻り値として返す
    BCrypt::Password.new(remember_digest).is_password?(remember_token) # DBのremember_digestと、受け取った引数をremember_digestにした値を比較し、ture・felseで返す
    # module BCryptで「is_password?」メソッドを定義しており、「==」と同じ意味。参照：https://github.com/codahale/bcrypt-ruby/blob/master/lib/bcrypt/password.rb
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)  # DBにあるremember_digestをnilにする
  end

end
