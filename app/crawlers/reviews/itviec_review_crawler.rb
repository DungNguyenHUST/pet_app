
require_relative 'common_review_crawler.rb'
include CommonReviewCrawler

module ItviecReviewCrawler
    def get_detail_review_data_itviec(crawl_review)
        processing_detail_datas = []
        if crawl_review.company_id.present?
            @company = Company.friendly.find_by_id(crawl_review.company_id)

            if check_exist_url(crawl_review.url.to_s)
                if crawl_review.raw_data.present?
                    doc = Nokogiri::HTML(crawl_review.raw_data)
                else
                    response = HTTParty.get(crawl_review.url.to_s)
                    doc = Nokogiri::HTML(response.body)
                end

                review_blocks = doc.css("div.content-of-review")

                review_blocks.each do |review_block|
                    if review_block.css("h3.short-title").first.present?
                        review_title = review_block.css("h3.short-title").first.text.strip
                    end
                    
                    if review_block.css("div.stars-and-recommend span.blue-stars img.small").first.present?
                        score = review_block.css("span.blue-stars img.small").count
                    end

                    if score > 5
                        score = 5
                    end
                    
                    if review_block.css("div.stars-and-recommend div.recommend span.yes").first.present?
                        recommend = true
                    else
                        recommend = false
                    end

                    if review_block.css("div.what-you-liked p").first.present?
                        pros = review_block.css("div.what-you-liked p").first.text.strip
                    end

                    if review_block.css("div.feedback p").first.present?
                        cons = review_block.css("div.feedback p").first.text.strip
                    end

                    review = ""
                    user_name = "Ẩn danh"
                    position = ""
                    start_date = Time.now - 30.days
                    end_date = Time.now
                    working_status = true
                    average_score = score
                    privacy = false
                    working_time = ""
                    user_id = Admin.first.id
                    career_score = 0
                    manager_score = 0
                    ot_score = 0
                    salary_score = 0
                    work_env_score = 0

                    if review_title.present? && score.present?
                        review_data_temp = review_params.new(@company.name,
                                                            score,
                                                            @company.id,
                                                            user_name,
                                                            review,
                                                            start_date,
                                                            end_date,
                                                            position,
                                                            pros,
                                                            cons,
                                                            review_title,
                                                            career_score,
                                                            manager_score,
                                                            ot_score,
                                                            salary_score,
                                                            work_env_score,
                                                            working_status,
                                                            average_score,
                                                            privacy,
                                                            working_time,
                                                            user_id,
                                                            recommend)

                        processing_detail_datas.push(review_data_temp)
                    end
                end
                    
                return processing_detail_datas
            end
        else
            return nil
        end
    end
end