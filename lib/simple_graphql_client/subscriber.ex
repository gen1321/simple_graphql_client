defmodule SimpleGraphqlClient.Subscriber do
  @moduledoc """
    Handles data transformation for genserver call.
  """
  alias SimpleGraphqlClient.SubscriptionServer

  @name_regex ~r/(?<=subscription\s).*(?=\s\{)/
  @variable_regex ~r/\$([a-zA-Z0-9_-]*): ([a-zA-Z!_-]*)/

  @doc """
   Handles absinthe subscription with help of Subscritpion genserver.
  """
  def absinthe_sub(query, variables, callback_or_dest, _opts) do
    SubscriptionServer.subscribe(
      get_subscription_name(query, variables),
      callback_or_dest,
      query,
      variables
    )
  end

  def get_subscription_name(query, variables) do
    @name_regex
    |> Regex.run(query)
    |> List.first()
    |> interpolate_variables(variables)
  end

  defp interpolate_variables(name, variables) do
    variables =
      @variable_regex
      |> Regex.scan(name, capture: :all_but_first)
      |> Enum.map(fn [name, _] ->
        value = Map.get(variables, name)
        "$#{name}: #{inspect(value)}"
      end)
      |> Enum.join(", ")

    name =
      name
      |> String.split("(")
      |> List.first()

    "#{name}(#{variables})"
  end
end
