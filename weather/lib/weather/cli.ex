defmodule Weather.CLI do

  def main(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
  end

  def parse_args([code]), do: {code}

  def parse_args(_), do: :help

  def process({code}) do
    Weather.Nora.fetch(code)
    |> print_table
  end

  def process(:help) do
    IO.puts """
    weather <code>
    """
  end

  def print_table({:error, _}) do
    IO.puts "Error while getting data from Nora"
    System.halt(2)
  end

  def print_table({_, body: body}) do
    IO.puts "hello"
  end

end
