defmodule ExfileS3.Backend do
  use Exfile.Backend

  def init(opts) do
    {:ok, backend} = super(opts)
    ExfileS3.Config.get(backend, :access_key_id)     || raise(ArgumentError, message: "access_key_id is required.")
    ExfileS3.Config.get(backend, :secret_access_key) || raise(ArgumentError, message: "secret_access_key is required.")
    ExfileS3.Config.get(backend, :region)            || raise(ArgumentError, message: "region is required.")
    ExfileS3.Config.get(backend, :bucket)            || raise(ArgumentError, message: "bucket is required.")

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

  def upload(backend, %Exfile.LocalFile{} = uploadable) do
    file_id = backend.hasher.hash(uploadable)
    case Exfile.LocalFile.open(uploadable) do
      {:ok, io} ->
        perform_upload(backend, file_id, io)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def perform_upload(backend, file_id, io) do
    case IO.binread(io, :all) do
      {:error, reason} ->
        {:error, reason}
      iodata ->
        ExfileS3.Client.put_object(backend, path(backend, file_id), iodata)
        {:ok, get(backend, file_id)}
    end
  end

  def open(backend, file_id) do
    case ExfileS3.Client.get_object(backend, path(backend, file_id)) do
      {:ok, %{body: body}} ->
        {:ok, io} = File.open(body, [:ram, :binary, :read])
        {:ok, %Exfile.LocalFile{io: io}}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def delete(backend, file_id) do
    case exists?(backend, file_id) do
      true  ->
        ExfileS3.Client.delete_object(backend, path(backend, file_id)) |> elem(0)
      false ->
        :ok
    end
  end

  def size(backend, file_id) do
    case ExfileS3.Client.head_object(backend, path(backend, file_id)) do
      {:ok, %{headers: headers}} ->
        {"Content-Length", size} = Enum.find(headers, fn({header_name, _}) -> header_name == "Content-Length" end)
        {size, _} = Integer.parse(size)
        {:ok, size}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def exists?(backend, file_id) do
    case ExfileS3.Client.head_object(backend, path(backend, file_id)) do
      {:ok, _} -> true
      _ -> false
    end
  end

  def path(backend, id) do
    [backend.backend_name, id]
    |> Enum.reject(&is_empty?/1)
    |> Enum.join("/")
  end

  defp is_empty?(elem) do
    string = to_string(elem)
    Regex.match?(~r/^\s*$/, string)
  end
end
