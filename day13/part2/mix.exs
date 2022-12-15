defmodule Part1.MixProject do
  use Mix.Project

  def project do
    [
      app: :part1,
      version: "1.0.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.4"}   
    ]
  end
end
