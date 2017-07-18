defmodule ExfileS3.Config do
  def get(_,     :access_key_id), do: s3_config() |> Keyword.get(:access_key_id)
  def get(_, :secret_access_key), do: s3_config() |> Keyword.get(:secret_access_key)
  def get(_,            :bucket), do: s3_config() |> Keyword.get(:bucket)
  def get(_,            :region), do: s3_config() |> Keyword.get(:region)

  defp s3_config, do: Application.get_env(:ex_aws, :s3)
end
