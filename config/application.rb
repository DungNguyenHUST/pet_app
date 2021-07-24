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
    
    #For CKEditor
    config.assets.precompile += Ckeditor.assets
    config.assets.precompile += %w( ckeditor/* ckeditor_assets/* *.png *.jpg *.jpeg *.gif img/*)
    config.encoding = "utf-8"
    config.assets.paths << "#{Rails}/vendor/assets/*"
    config.autoload_paths += %w(#{config.root}/app/models/ckeditor)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # job adapter
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths += %W(#{config.root}/app/workers)
    config.eager_load_paths += %W(#{config.root}/app/workers)
  end
end
