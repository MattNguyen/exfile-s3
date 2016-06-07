# ExfileS3

An AWS S3 adapteer for Exfile, using the ex_aws client library to interface with S3.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add exfile_s3 to your list of dependencies in `mix.exs`:

        def deps do
          [{:exfile_s3, "~> 0.0.1"}]
        end

  2. Ensure exfile_s3 is started before your application:

        def application do
          [applications: [:exfile_s3]]
        end

  3. Configure the backend in config.exs (or environment equivalent)

        config :exfile, Exfile,
          backends: %{
            "store": {ExfileS3.Backend,
              hasher: Exfile.Hasher.Random,
              access_key_id: "AWS Access Key Id",
              secret_access_key: "AWS Secret Access Key",
              s3_prefix: "bucket prefix",
              bucket_region: "Bucket Region",
              cdn_host: "CDN Host",
              bucket: "Name of the bucket to store files"
            }
          }
