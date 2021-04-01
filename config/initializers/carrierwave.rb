CarrierWave.configure do |config|
    config.permissions = 0666
    config.directory_permissions = 0777
    config.fog_provider = 'fog/google'
    config.fog_credentials = {
        provider: 'Google',
        google_project: Rails.application.secrets.google_cloud_storage_project_name,
        google_json_key_string: Rails.application.secrets.google_cloud_storage_credential_content
        # can optionally use google_json_key_location if using an actual file;
    }
    config.fog_directory = Rails.application.secrets.google_cloud_storage_bucket_name
end