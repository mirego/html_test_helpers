defmodule HTMLTestHelpers.MixProject do
  use Mix.Project

  def project do
    [
      app: :html_test_helpers,
      version: "0.1.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/mirego/html_test_helpers"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # HTML
      {:floki, "~> 0.24.0"},

      # Linting
      {:credo, "~> 1.1", only: [:dev, :test], override: true},
      {:credo_naming, "~> 0.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    "HTMLTestHelpers provides function helpers for unit testing allowing easy assertions for HTML elements data queried by data-testid attribute."
  end

  defp package do
    [
      organization: "mirego",
      licences: ["BSD-3-Clause"],
      links: %{"GitHub" => "https://github.com/mirego/html_test_helpers"}
    ]
  end
end
