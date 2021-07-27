class ScrapWorker
    include Sidekiq::Worker

    def perform(*args)
        processing_data
    end

	def get_data_itviec(url, company_name)
        # Root link
		response = HTTParty.get(url.to_s)
        doc = Nokogiri::HTML(response.body)

        # Get job link in to map
        processing_block = doc.css("h4.title")
        links = processing_block.css("a").map { |link| link['href']}
        links.map { |h| h.to_s.prepend("https://itviec.com/")}			
		
		# Start to get data
		processing_datas = []
		links.each do |link|
			response = HTTParty.get(link.to_s)
        	doc = Nokogiri::HTML(response.body)

			title = doc.css("h1.job-details__title").first.text.strip
			
			# get detail
			start_detail = doc.at_css("div.job-details__divider")
			end_detail = doc.at_css("div.jd-page__employer-overview")
			detail = ''
			next_step = 0
			loop do
				break if next_step == 8 # stop before end_detail
				start_detail = start_detail.next_element
				detail << start_detail.to_s
				next_step += 1
			end
			location = "Hà Nội"
			salary = "Thương lượng"
			quantity = 1
			category = "IT"
			language = "Tùy chọn"
			level = "Nhân viên"
			dudate = Time.now
			end_date = Time.now + 30.days
			job_type = "Full Time"
			urgent = false
			apply_another_site_flag = true
			apply_site = link.to_s
			address = "Hà Nội"
			approved = true
			user_id = 1

			# get company id by path
			if company_name == "FPT"
				company_id = 5 #FPT
			elsif company_name == "TECHCOMBANK"
				company_id = 25
			elsif company_name == "LG"
				company_id = 5
			else
				company_id = 1
			end

			data_temp = job_params.new(title,
									detail,
									location, 
									salary, 
									quantity, 
									category,
									language, 
									level,
									dudate,
									end_date,
									job_type, 
									urgent, 
									apply_another_site_flag, 
									apply_site, 
									address,
									user_id,
									approved,
									company_id)

			processing_datas.push(data_temp)
		end

		return processing_datas
	end

	def get_data_careerbuilder(url, company_name)
        # Root link
		response = HTTParty.get(url.to_s)
        doc = Nokogiri::HTML(response.body)

        # Get job link in to map
		processing_block = doc.css("div.figcaption div.title")
		links = processing_block.css("a").map { |link| link['href']}
		
		# Start to get data
		processing_datas = []
		links.each do |link|
			response = HTTParty.get(link.to_s)
        	doc = Nokogiri::HTML(response.body)

			title = doc.css("h1.title").first.text.strip
			
			# get detail
			start_detail = doc.at_css("div.detail-row")
			end_detail = doc.at_css("div.share-this-job")
			detail = ''
			next_step = 0
			loop do
				break if next_step == 3 # stop before end_detail
				detail << start_detail.to_s
				start_detail = start_detail.next_element
				next_step += 1
			end
			location = "Hà Nội"
			salary = "Thương lượng"
			quantity = 1
			category = "IT"
			language = "Tùy chọn"
			level = "Nhân viên"
			dudate = Time.now
			end_date = Time.now + 30.days
			job_type = "Full Time"
			urgent = false
			apply_another_site_flag = true
			apply_site = link.to_s
			address = "Hà Nội"
			approved = true
			user_id = 1

			# get company id by path
			if company_name == "FPT"
				company_id = 5 #FPT
			elsif company_name == "TECHCOMBANK"
				company_id = 25
			elsif company_name == "LG"
				company_id = 5
			else
				company_id = 1
			end

			data_temp = job_params.new(title,
									detail,
									location, 
									salary, 
									quantity, 
									category,
									language, 
									level,
									dudate,
									end_date,
									job_type, 
									urgent, 
									apply_another_site_flag, 
									apply_site, 
									address,
									user_id,
									approved,
									company_id)

			processing_datas.push(data_temp)
		end

		return processing_datas
	end

	def processing_job(job_datas)
		job_datas.each do |job_data|
			@company = Company.find_by_id(job_data.company_id)
			@company_job = @company.company_jobs.create!(:title => job_data.title,
														:detail => job_data.detail,
														:location => job_data.location,
														:salary => job_data.salary,
														:quantity => job_data.quantity,
														:category => job_data.category,
														:language => job_data.language,
														:level => job_data.level,
														:dudate => job_data.dudate,
														:end_date => job_data.end_date,
														:job_type => job_data.job_type,
														:urgent => job_data.urgent,
														:apply_another_site_flag => job_data.apply_another_site_flag,
														:apply_site => job_data.apply_site,
														:address => job_data.address,
														:user_id => job_data.user_id,
														:approved => job_data.approved)
			@company_job.save!
		end
	end

	def job_params
        job_param = Struct.new(:title,
							:detail,
							:location, 
							:salary, 
							:quantity, 
							:category, 
							:language, 
							:level, 
							:dudate,
							:end_date,
							:job_type, 
							:urgent, 
							:apply_another_site_flag, 
							:apply_site, 
							:address,
							:user_id,
							:approved,
							:company_id)
    end

    def processing_data
        puts "Start scrap data..."
		# processing_job(get_data_itviec("https://itviec.com/nha-tuyen-dung/techcombank", "TECHCOMBANK"))
        # processing_job(get_data_itviec("https://itviec.com/nha-tuyen-dung/fpt-software", "FPT"))
		# processing_job(get_data_itviec("https://itviec.com/nha-tuyen-dung/lg-vehicle-component-solutions-development-center-vietnam-lg-vs-dcv", "LG"))
		processing_job(get_data_careerbuilder("https://careerbuilder.vn/vi/nha-tuyen-dung/fpt-telecom-chi-nhanh-cong-ty-co-phan-vien-thong-fpt.35A8CF49.html", "FPT"))
        puts "End scrap data!!!"
    end
end
