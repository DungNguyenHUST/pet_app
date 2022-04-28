class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable, :trackable,
            :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

    extend FriendlyId
    def convert_slug
        slug = name.downcase.to_s
        slug.gsub! /[àáạãảâậấẫầẩăặắằẵẳ]/, "a"
        slug.gsub! /[đ]/, "d"
        slug.gsub! /[èéẹẽẻêềếệễể]/, "e"
        slug.gsub! /[óòọõỏôốồộỗổơớợỡờở]/, "o"
        slug.gsub! /[úùụũủưứựừữử]/, "u"
        slug.gsub! /[íịìĩỉ]/, "i"
        slug.gsub! /[ýỵỹỳỷ]/, "y"
        return slug
    end
    friendly_id :convert_slug, use: :slugged

    mount_uploader :avatar, ImageUploader
    mount_uploader :wall_picture, ImageUploader
    mount_uploader :cover_letter_attach, FileUploader

    has_many :company_follows, dependent: :destroy
    has_many :company_save_jobs, dependent: :destroy
    has_many :user_notifications, dependent: :destroy
    has_many :user_educations, dependent: :destroy
    has_many :user_experiences, dependent: :destroy
    has_many :user_skills, dependent: :destroy
    has_many :user_certificates, dependent: :destroy
    has_many :user_adwards, dependent: :destroy

    # after_create :send_welcome_email

    # For Search
    searchkick inheritance: true

    def search_data
        {
            name: name,
            sex: sex,
            address: address,
            email: email,
            updated_at: updated_at,
            created_at: created_at,
            public: public,
            user_educations_school_name: user_educations.map(&:school_name).join(' '),
            user_educations_school_field: user_educations.map(&:school_field).join(' '),
            user_educations_school_level: user_educations.map(&:school_level).join(' '),
            user_educations_cert_type: user_educations.map(&:cert_type).join(' '),
            user_educations_cert_level: user_educations.map(&:cert_level).join(' '),
            user_experiences_job_level: user_experiences.map(&:job_level).join(' '),
            user_experiences_company_name: user_experiences.map(&:company_name).join(' '),
            user_experiences_time: cal_user_experience.to_i,
            user_adwards: user_adwards.map(&:adward_name).join(' '),
            user_certificates: user_certificates.map(&:cert_name).join(' '),
            user_skills: user_skills.map(&:skill_name).join(' ')
        }
    end

    def cal_user_experience
        exp = 0
        user_exp = self.user_experiences.sort_by{|data| data.start_date}
        unless user_exp.first.nil?
            exp = Time.now.year - user_exp.first.start_date.year
        end
        return exp
    end
        
    def self.approved
        where(approved: :true)
    end

    def self.public
        where(public: :false)
    end

    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name   # assuming the user model has a name
        user.avatar = auth.info.image # assuming the user model has an image
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
