defmodule ExfileS3.S3 do
  use ExAws.S3.Client

  @valid_options [:access_key_id, :secret_access_key, :prefix, :region, :cdn_host, :bucket]

  def config_root do
    %{"store" => {ExfileS3.Backend, s3_config}} = Application.get_env(:exfile, Exfile, []) |> Keyword.get(:backends, %{})
    s3_config = s3_config |> Keyword.take(@valid_options)
    [s3: s3_config]
  end

  def find_config_value(key) do
    config_root |> Keyword.get(:s3) |> Keyword.get(key)
  end
end
