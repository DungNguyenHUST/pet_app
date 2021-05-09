class User < ApplicationRecord
	extend FriendlyId
	friendly_id :name, use: :slugged
	
    # using encryt pass
    has_secure_password
    
    before_save { self.email = email.downcase }
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

    belongs_to :company, optional: true
	
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

end
