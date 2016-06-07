defmodule ExfileS3.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exfile_s3,
      version: "0.0.1",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      description: description,
      package: package
    ]
  end

  defp description do
    """
    An AWS S3 adapteer for Exfile, using the ex_aws client library to interface with S3.
    """
  end

  defp package do
    [
      name: :exfile_s3,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Matt Nguyen"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/MattNguyen/exfile-s3"}
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:exfile, :ex_aws, :httpoison, :logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:exfile, "~> 0.3.1"},
      {:ex_aws, "~> 0.4.10"},
      {:sweet_xml, "~> 0.6.1"},
      {:httpoison, "~> 0.7"},
      {:poison, "~> 1.2"}
    ]
  end
end
