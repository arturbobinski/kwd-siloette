if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Figaro.env.aws_access_key_id,
      aws_secret_access_key: Figaro.env.aws_secret_access_key,
      region: 'us-east-1',
    }

    config.fog_directory  = Figaro.env.aws_bucket
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end
