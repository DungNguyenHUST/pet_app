class CrawlerCompanyJob < ApplicationJob
  @queue = :file_serve
	
	def perform(scrap_company_id)
		@scrap_company = ScrapCompany.find_by_id(scrap_company_id)
		CompanyCrawler.process(@scrap_company)
	end
end
