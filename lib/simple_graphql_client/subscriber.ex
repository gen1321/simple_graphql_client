defmodule SimpleGraphqlClient.Subscriber do
  alias SimpleGraphqlClient.SubscriptionServer
  import SimpleGraphqlClient.Config

  def absinthe_sub(query, variables, callback_or_dest, opts) do
    SubscriptionServer.subscribe(
      get_subscription_name(query),
      callback_or_dest,
      query,
      variables
    )
  end

  def get_subscription_name(query) do
    ~r/(?<=subscription\s).*(?=\s\{)/
    |> Regex.run(query)
    |> case do
      [hd] ->
        hd
      _ ->
        UUID.uuid4()
    end
  end
end
