# ExfileS3

An AWS S3 adapter for [exfile](https://github.com/keichan34/exfile), using the [ex_aws](https://github.com/CargoSense/ex_aws) client library to interface with S3.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `exfile_s3` to your list of dependencies in `mix.exs`:

      ```elixir
        def deps do
          [{:exfile_s3, "~> 0.0.3"}]
        end
      ```
  2. Ensure `exfile_s3` is started before your application:

      ```elixir
        def application do
          [applications: [:exfile_s3]]
        end
      ```

  3. Configure `ex_aws` in config.exs:

      ```elixir
        config :ex_aws, :s3,
          access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
          secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
          region: System.get_env("AWS_REGION"),
          bucket: System.get_env("AWS_S3_BUCKET")
      ```

  4. Add the `exfile` backend in config.exs (or environment equivalent)

      ```elixir
        config :exfile, Exfile,
          backends: %{
            "store" => {
              ExfileS3.Backend,
              hasher: Exfile.Hasher.Random,
              cdn_host: "CDN Host"
            },
            "cache" => {
              ExfileS3.Backend,
              hasher: Exfile.Hasher.Random,
              cdn_host: "CDN Host"
            }
          }
      ```
