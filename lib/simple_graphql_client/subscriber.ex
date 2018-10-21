defmodule SimpleGraphqlClient.Subscriber do
  alias SimpleGraphqlClient.SubscriptionServer
  import SimpleGraphqlClient.Config

  def sub(query, variables, callback, opts) do
    SubscriptionServer.subscribe(
      get_subscription_name(query),
      callback,
      query,
      variables
    )
  end

  def get_subscription_name(query) do
    ~r/(?<=subscription\s).*(?=\s\{)/
    |> Regex.run(query)
    |> hd
  end
end
