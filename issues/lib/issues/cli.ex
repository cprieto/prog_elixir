defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and dispatch to correct operations
  """

  def run(args) do
    parse_args(args)
  end

  @doc """
  This is the parsing function
  """
  def parse_args(args) do
    OptionParser.parse(
      args,
      switches: [
        help: :boolean
      ],
      aliases: [
        h: :help
      ]
    )
    |> elem(1)
    |> args_to_internal_repr
  end

  def args_to_internal_repr([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_repr([user, project]) do
    {user, project, @default_count}
  end

  def args_to_internal_repr(_) do
    :help
  end
end
