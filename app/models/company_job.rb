class CompanyJob < ApplicationRecord
    include PgSearch::Model
    
	extend FriendlyId
	def convert_slug
        slug = title.downcase.to_s
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
    
    has_many :company_apply_jobs, dependent: :destroy
    has_many :company_save_jobs, dependent: :destroy

    pg_search_scope :search_job_by_query, 
                    against: [[:title, 'A'], [:company_name, 'B'], [:category, 'C'], [:skill, 'D']], 
                    using: {
                        tsearch: { prefix: true, dictionary: "english", tsvector_column: "tsv" }
                    }

    pg_search_scope :search_job_by_location, 
                    against: :location,
                    using: {
                        tsearch: { prefix: true, dictionary: "english", tsvector_column: "tsv" }
                    }

    pg_search_scope :search_job_by_category, 
                    against: :category,
                    using: {
                        tsearch: { prefix: true, dictionary: "english", tsvector_column: "tsv" }
                    }

    pg_search_scope :search_job_by_typical, 
                    against: :typical,
                    using: {
                        tsearch: { prefix: true, dictionary: "english", tsvector_column: "tsv" }
                    }

    pg_search_scope :search_job_by_level, 
                    against: :level,
                    using: {
                        tsearch: { prefix: true, dictionary: "english", tsvector_column: "tsv" }
                    }

    def self.filtered(filter_params)
        job_filter = CompanyJob.all
        unless filter_params.search.nil?
            job_filter = job_filter.search_job_by_query(filter_params.search)
        end

        unless filter_params.location.nil?
            job_filter = job_filter.search_job_by_location(filter_params.location)
        end

        unless filter_params.category.nil?
            job_filter = job_filter.search_job_by_category(filter_params.category)
        end

        unless filter_params.salary_min.nil?
            job_filter = job_filter.where("salary_min >= ?", filter_params.salary_min.to_i)
        end

        unless filter_params.salary_max.nil?
            job_filter = job_filter.where("salary_max <= ?", filter_params.salary_max.to_i)
        end

        unless filter_params.typical.nil?
            job_filter = job_filter.search_job_by_typical(filter_params.typical)
        end

        unless filter_params.level.nil?
            job_filter = job_filter.search_job_by_level(filter_params.level)
        end

        unless filter_params.post_date.nil?
            job_filter = job_filter.where("created_at >= ?", filter_params.post_date.day.ago.utc)
        end

        if(job_filter)
            self.where(id: job_filter)
        end
    end
	
	def self.approved
	    where(approved: :true)
	end

    def self.expire
        where("end_date >= ?", Time.now).approved
    end
end
