class JobCrawlerWorker
	require 'sidekiq/api'
	include Sidekiq::Worker

	def perform(scrap_job_id)
		@scrap_job = ScrapJob.find_by_id(scrap_job_id)
		JobCrawler.process(@scrap_job)
	end

	def self.clear_sidekiq_queue
		# 1. Clear retry set
		Sidekiq::RetrySet.new.clear

		# 2. Clear scheduled jobs 
		Sidekiq::ScheduledSet.new.clear

		# 3. Clear 'Processed' and 'Failed' jobs
		Sidekiq::Stats.new.reset

		# 3. Clear 'Dead' jobs statistics
		Sidekiq::DeadSet.new.clear

		# Stats
		stats = Sidekiq::Stats.new
		stats.queues
		# {"production_mailers"=>25, "production_default"=>1}

		# Queue
		queue = Sidekiq::Queue.new('queue_name')
		queue.count
		queue.clear
		queue.each { |job| job.item } # hash content

		# Redis Acess
		Sidekiq.redis { |redis| redis.keys }
	end
end
