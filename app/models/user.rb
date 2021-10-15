class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable, :trackable,
            :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

    include PgSearch::Model

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

    pg_search_scope :search_user_by_query, 
                    against: [[:name, 'A'], [:email, 'B']], 
                    using: {
                        tsearch: { prefix: true, dictionary: "english", any_word: true }
                    }

    pg_search_scope :search_user_by_address, 
                    against: :address, 
                    using: {
                        tsearch: { prefix: true, dictionary: "english", any_word: true }
                    }

    pg_search_scope :search_user_by_sex, 
                    against: :sex, 
                    using: {
                        tsearch: { prefix: true, dictionary: "english", any_word: true }
                    }

    pg_search_scope :search_user_associate_by_query, 
                    associated_against: {
                        user_educations: [:school_name, :cert_type],
                        user_experiences: [:job_level, :company_name],
                        user_skills: :skill_name,
                        user_adwards: :adward_name,
                        user_certificates: :cert_name
                    },
                    using: {
                        tsearch: { prefix: true, dictionary: "english", any_word: true }
                    }

    pg_search_scope :search_user_associate_by_edu, 
                    associated_against: {
                        user_educations: :school_level
                    },
                    using: {
                        tsearch: { prefix: true, dictionary: "english", any_word: true }
                    }

    pg_search_scope :search_user_associate_by_exp, 
                    associated_against: {
                        user_experiences: :job_level
                    },
                    using: {
                        tsearch: { prefix: true, dictionary: "english", any_word: true }
                    }

    def cal_user_experience
        exp = 0
        user_exp = self.user_experiences.sort_by{|data| data.start_date}
        unless user_exp.first.nil?
            exp = Time.now.year - user_exp.first.start_date.year
        end
        return exp
    end

    def self.filtered(filter_params)
        user_filter = User.all
        
        unless filter_params.search.nil?
            user_filter = user_filter.search_user_associate_by_query(filter_params.search)
        end

        unless filter_params.location.nil?
            user_filter = user_filter.search_user_by_address(filter_params.location)
        end

        unless filter_params.sex.nil?
            user_filter = user_filter.search_user_by_sex(filter_params.sex)
        end

        unless filter_params.school_level.nil?
            user_filter = user_filter.search_user_associate_by_edu(filter_params.school_level)
        end

        unless filter_params.job_level.nil?
            user_filter = user_filter.search_user_associate_by_exp(filter_params.job_level)
        end

        unless filter_params.job_exp.nil?
            user_filter = user_filter.map{|m| m.cal_user_experience >= filter_params.job_exp.to_i}
        end

        unless filter_params.updated_date.nil?
            user_filter = user_filter.where("updated_at >= ?", filter_params.updated_date.day.ago.utc)
        end

        if(user_filter)
            self.where(id: user_filter)
        end
    end
        
    def self.approved
        where(approved: :true)
    end

    def self.public
        where(public: :true)
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
