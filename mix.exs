defmodule SimpleGraphqlClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_graphql_client,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.3.1"},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:mock, "~> 0.3.0", only: :test},
      {:poison, "~> 3.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
