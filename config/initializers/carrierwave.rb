CarrierWave.configure do |config|
    config.fog_provider = 'fog/google'
    config.fog_credentials = {
        provider: 'Google',
        google_project: 'pet-app',
        google_json_key_string: '../pet-app-google-storage-key.json'
        # can optionally use google_json_key_location if using an actual file;
    }
    config.fog_directory = 'pet-app'
end