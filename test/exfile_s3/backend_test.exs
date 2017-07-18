defmodule ExfileS3.BackendTest do
  use Exfile.BackendTest, {
    ExfileS3.Backend, name: "test"
  }

  alias Exfile.LocalFile

  test "uploading a file through S3 backend works", %{backend: backend} do
    string         = "hello from S3"
    {:ok, file}    = upload_string(backend, string)
    {:ok, file2}   = Backend.upload(backend, file)
    {:ok, s3_file} = Backend.open(backend, file2.id)

    assert IO.binread(s3_file.io, :all) == string
  end
end
