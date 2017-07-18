use Mix.Config

config :ex_aws, :s3,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION"),
  bucket: System.get_env("AWS_S3_BUCKET")
