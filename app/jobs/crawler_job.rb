class CrawlerJob < ApplicationJob
	@queue = :file_serve
	
	def perform(scrap_job_id)
		@scrap_job = ScrapJob.find_by_id(scrap_job_id)
		JobCrawler.process(@scrap_job)
	end
end
