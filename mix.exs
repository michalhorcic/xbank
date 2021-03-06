defmodule Xbank.Mixfile do
  use Mix.Project

  def project do
    [app: :xbank,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Xbank is a hub for working with different bank APIs",
     package: package,
     deps: deps()]
  end

  def package do
    [ name: :xbank,
      files: ["lib", "mix.exs"],
      maintainers: ["Michal Horcic"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/michalhorcic/xbank"},
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.10.0"},
      {:poison, "~> 2.0"},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
