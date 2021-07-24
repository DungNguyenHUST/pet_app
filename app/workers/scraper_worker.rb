class ScraperWorker
    include Sidekiq::Worker

    def perform(*args)
        processing_data
    end

    def get_data_fpt
        response = HTTParty.get('https://itviec.com/viec-lam-it/fpt/ha-noi')
        doc = Nokogiri::HTML(response.body)
        
        # Get job link block
        processing_block = doc.css("h2.title")
        links = processing_block.css("a").map { |link| link['href']}
        links.map { |h| h.to_s.prepend("https://itviec.com/")}

		data = Struct.new(:title, :detail)
		# links.each do |link|
			response = HTTParty.get(links.first.to_s)
        	doc = Nokogiri::HTML(response.body)
			title = doc.css("h1.job-details__title").first
			detail = doc.css("div.job-details__paragraph").first
		# end

		@company_job = CompanyJob.new
		@company_job.company_id = 5
		@company_job.title = title
		@company_job.detail = detail
		@company_job.approved = true
		@company_job.save!
        # return processing_datas
    end

    def processing_post(post_data)
        # @post = Post.new
        # @post.title = post_data.title
        # @post.link = post_data.link
        # @post.user_id = 1
    end

    def processing_data
        puts "Start scrap data..."
        get_data_fpt.first(5).each do |processing_data|
            processing_post(processing_data)
        end
        puts "End scrap data!!!"
    end
end
