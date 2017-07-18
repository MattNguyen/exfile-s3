defmodule ExfileS3.Client do

  def get_object(backend, path) do
    backend
    |> get_bucket()
    |> ExAws.S3.get_object(path)
    |> ExAws.request
  end

  def put_object(backend, path, iodata) do
    backend
    |> get_bucket()
    |> ExAws.S3.put_object(path, iodata)
    |> ExAws.request
  end

  def delete_object(backend, path) do
    backend
    |> get_bucket()
    |> ExAws.S3.delete_object(path)
    |> ExAws.request
  end

  def head_object(backend, path) do
    backend
    |> get_bucket()
    |> ExAws.S3.head_object(path)
    |> ExAws.request
  end

  defp get_bucket(backend), do: ExfileS3.Config.get(backend, :bucket)
end
