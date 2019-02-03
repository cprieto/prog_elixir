defmodule Weather.Nora do
  import SweetXml

  @nora_url Application.get_env(:issues, :nora_url)
  @user_agent [{"User-Agent", "elixir"}]
  @schema [
    location: ~x"./location/text()",
    station: ~x"./station/text()",
    latitude: ~x"./latitude/text()",
    longitude: ~x"./longitude/text()",
    weather: ~x"./weather/text()",
    temperature: ~x"./temperature_string/text()",
    humidity: ~x"./relative_humidity/text()",
    wind: ~x"./wind_string/text()",
    pressure: ~x"./pressure_string/text()",
    dewpoint: ~x"./dewpoint_string/text()",
    windchill: ~x"./windchill_string/text()",
    visibility: ~x"./visibility_mi/text()"
  ]

  def get_nora_url(code), do: "#{@nora_url}/xml/current_obs/#{code}.xml"
  def check_for_error(200), do: :ok
  def check_for_error(_), do: :error

  def process_response({_, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error,
      body |> xpath(~x"//current_observation"e) |> xmap(@schema)
    }
  end

  def fetch(code) do
    code
    |> get_nora_url
    |> HTTPoison.get(@user_agent)
    |> process_response
  end
end
