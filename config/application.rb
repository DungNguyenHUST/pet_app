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
    config.active_job.queue_adapter = :resque
    config.autoload_paths += %W(#{config.root}/app/workers)
    config.eager_load_paths += %W(#{config.root}/app/workers)

    # Search optimize
    config.active_record.schema_format = :sql

    # Where the I18n library should search for translation files
    I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]

    # Permitted locales available for the application
    I18n.available_locales = [:en, :vi]

    # Set default locale to something other than :en
    I18n.default_locale = :vi

    # Load constants in lib
    config.autoload_paths << "#{Rails.root}/lib"
  end
end
