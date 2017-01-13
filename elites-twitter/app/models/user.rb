class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :name, presence: true, length: { minimum: 8 }, uniqueness: true
  validates_email_format_of :email, uniqueness: true, :message => '正しいメールアドレスの形式で入力してください。'
  validates :image, presence: true
  validates :profile, presence: true
  
  mount_uploader :image, UserThumbnailUploader
end
