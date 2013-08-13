CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => ENV['ACCESS_KEY'],                        # required
      :aws_secret_access_key  => ENV['SECRET_ACCESS'],                        # required
    }
    config.fog_directory  = 'myflix0813'                     # required
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end