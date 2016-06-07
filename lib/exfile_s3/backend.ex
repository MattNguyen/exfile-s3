defmodule ExfileS3.Backend do
  use Exfile.Backend

  alias Exfile.LocalFile
  alias ExfileS3.S3

  def init(opts) do
    _access_key_id     = Keyword.get(opts, :access_key_id)     || raise(ArgumentError, message: "access_key_id is required.")
    _secret_access_key = Keyword.get(opts, :secret_access_key) || raise(ArgumentError, message: "secret_access_key is required.")
    _bucket            = Keyword.get(opts, :bucket)            || raise(ArgumentError, message: "bucket is required.")
    {:ok, backend} = super(opts)
    backend
  end

  def upload(backend, %Exfile.File{} = uploadable) do
    case Exfile.File.open(uploadable) do
      {:ok, local_file} ->
        upload(backend, local_file)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def upload(backend, %LocalFile{} = uploadable) do
    id = backend.hasher.hash(uploadable)
    case LocalFile.open(uploadable) do
      {:ok, io} ->
        perform_upload(backend, id, io)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def perform_upload(backend, file_id, io) do
    case IO.binread(io, :all) do
      {:error, reason} ->
        {:error, reason}
      iodata ->
        S3.put_object(S3.find_config_value(:bucket), path(backend, file_id), iodata)
        {:ok, get(backend, file_id)}
    end
  end

  def open(backend, file_id) do
    case S3.get_object(S3.find_config_value(:bucket), path(backend, file_id)) do
      {:ok, %{body: body}} ->
        {:ok, io} = StringIO.open(body)
        {:ok, %LocalFile{io: io}}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def delete(backend, file_id) do
    S3.delete_object(S3.find_config_value(:bucket), path(backend, file_id))
  end

  def size(backend, file_id) do
    case S3.head_object(S3.find_config_value(:bucket), path(backend, file_id)) do
      {:ok, %{headers: headers}} ->
        {"Content-Length", size} = Enum.find(headers, fn({header_name, _}) -> header_name == "Content-Length" end)
        {size, _} = Integer.parse(size)
        {:ok, size}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def exists?(backend, file_id) do
    case S3.head_object(S3.find_config_value(:bucket), path(backend, file_id)) do
      {:ok, _} -> true
      _ -> false
    end
  end

  def path(_backend, id) do
    [S3.find_config_value(:prefix), id]
    |> Enum.reject(&is_empty?/1)
    |> Enum.join("/")
  end

  defp is_empty?(elem) do
    string = to_string(elem)
    Regex.match?(~r/^\s*$/, string)
  end
end
