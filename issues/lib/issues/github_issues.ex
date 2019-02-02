defmodule Issues.GithubIssues do
  @github_url Application.get_env(:issues, :github_url)
  @user_agent [{"User-agent", "Elixir test@example.com"}]

  def issues_url(user, project), do: "#{@github_url}/repos/#{user}/#{project}/issues"

  def check_for_error(200), do: :ok
  def check_for_error(_), do: :error

  def handle_response({_, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error,
      body        |> Poison.Parser.parse!()
    }
  end

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end
end