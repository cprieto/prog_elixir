defmodule Issues.CLI do
  import Issues.TableFormatter, only: [print_table_for_columns: 2]

  @default_count 4

  @moduledoc """
  Handle the command line parsing and dispatch to correct operations
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
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

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_into_descending_order
    |> last(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count |#{@default_count} ]
    """

    System.halt(0)
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i, j -> i["created_at"] >= j["created_at"] end)
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse
  end

  def args_to_internal_repr([user, project, count]), do: {user, project, String.to_integer(count)}

  def args_to_internal_repr([user, project]), do: {user, project, @default_count}

  def args_to_internal_repr(_), do: :help

  def decode_response({:error, error}) do
    IO.puts "Error fetching from Github: #{error["message"]}"
    System.halt(2)
  end

  def decode_response({:ok, body}), do: body

end
