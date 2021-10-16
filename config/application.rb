require_relative 'boot'

require 'rails/all'

require 'rails_autolink'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PetApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
    # Crawler
    config.autoload_paths += %W(#{config.root}/app/crawlers/jobs)
    config.eager_load_paths += %W(#{config.root}/app/crawlers/jobs)
    config.autoload_paths += %W(#{config.root}/app/crawlers/reviews)
    config.eager_load_paths += %W(#{config.root}/app/crawlers/reviews)

    # Job worker
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths += %W(#{config.root}/app/workers)
    config.eager_load_paths += %W(#{config.root}/app/workers)

    # Search optimize
    config.active_record.schema_format = :sql
  end
end
