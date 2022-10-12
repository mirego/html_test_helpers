defmodule HTMLTestHelpers.MixProject do
  use Mix.Project

  def project do
    [
      app: :html_test_helpers,
      version: "0.1.6",
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
      {:floki, "~> 0.32.1"},

      # Linting
      {:credo, "~> 1.6", only: [:dev, :test], override: true},
      {:credo_naming, "~> 2.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.28.4", only: :dev, runtime: false}
    ]
  end

  defp description do
    "HTMLTestHelpers provides function helpers for unit testing allowing easy assertions for HTML elements data queried by data-testid attribute."
  end

  defp package do
    [
      licenses: ["BSD-3-Clause"],
      links: %{"GitHub" => "https://github.com/mirego/html_test_helpers"}
    ]
  end
end
