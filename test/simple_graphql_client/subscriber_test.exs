defmodule SimpleGraphqlClientTest.Subscriber do
  use ExUnit.Case
  alias SimpleGraphqlClient.Subscriber

  @proper_query """
  subscription coolName {
    quizFinish{
      timeBonus
    }
  }
  """

  describe "get_subscription_name" do
    test "returns name from properly formated sub" do
      assert Subscriber.get_subscription_name(@proper_query) == "coolName"
    end
  end
end
