class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  
	extend FriendlyId
	friendly_id :name, use: :slugged
	
  # using encryt pass
  # has_secure_password
  
  # before_save { self.email = email.downcase }
  # validates :name, presence: true
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  # validates :password, presence: true, length: { minimum: 6 }

  # has_one_attached :avatar
  # has_one_attached :cover_letter_attach
  mount_uploader :avatar, ImageUploader
  mount_uploader :cover_letter_attach, FileUploader

  has_many :company_like_reviews, dependent: :destroy
  has_many :company_dislike_reviews, dependent: :destroy

  has_many :company_like_interviews, dependent: :destroy
  has_many :company_dislike_interviews, dependent: :destroy

  has_many :problem_vote_solutions, dependent: :destroy
  has_many :problem_unvote_solutions, dependent: :destroy

  has_many :company_follows, dependent: :destroy

  has_many :company_save_jobs, dependent: :destroy

  has_many :user_notifications, dependent: :destroy

  belongs_to :company, optional: true

  # after_create :send_welcome_email
	
	def self.approved
	  where(approved: :true)
	end

  def self.search(search)
    if search
      user_type = User.where("name ILIKE? OR email ILIKE?", "%#{search}%", "%#{search}%")
      if(user_type)
        self.where(id: user_type)
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.picture = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email . blank? 
      end 
    end 
  end 

  def send_welcome_email
    UserMailer.welcome_email(self).deliver
  end
end
