#  Micropostモデルを生成「rails generate model Micropost content:text user:references」
class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
   # コマンドを実行したときにuser:referencesという引数も含めていたため、ユーザーと１対１の関係であることを表すbelongs_toのコードも追加されています。
   mount_uploader :picture, PictureUploader
   # CarrierWaveに画像と関連付けたモデルを伝えるためには、mount_uploaderというメソッドを使います。このメソッドは、引数に属性名のシンボルと生成されたアップローダーのクラス名を取ります。(app/uploaders/picture_uploader.rbというファイルでPictureUploaderクラスが定義されています。
   validates :user_id, presence: true
   validates :content, presence: true, length: { maximum: 140 }

   # アップロードされた画像のサイズをバリデーションする
   # validatesメソッドではなく、validateメソッドを使っている点に注意
   validate  :picture_size

   # 独自のバリデーションpicture_sizeメソッドを定義 => アップロードされた画像のサイズをバリデーションする
   def picture_size
     # 5MBを上限とし、それを超えた場合はカスタマイズしたエラーメッセージをerrorsコレクションに追加
     if picture.size > 5.megabytes
       errors.add(:picture, "should be less than 5MB")
     end
   end

end
