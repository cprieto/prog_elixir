defmodule Weather.CLI do
  require Logger

  def main(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> parse_args
    |> process
  end

  def parse_args({_, [code], _}), do: {code}
  def parse_args(_), do: :help

  def process({code}) do
    Logger.info "Grabbing info for #{code}"
    Weather.Nora.fetch(code)
    |> print_table
  end

  def process(:help) do
    IO.puts """
    Usage:
    weather <code>
    """
  end

  def print_table({:error, _}) do
    IO.puts "Error while getting data from Nora"
    System.halt(2)
  end

  def print_table({_, content}) do
    content
    |> Enum.map(fn {k, v} -> %{key: k, value: v} end)
    |> Scribe.print
  end

end
