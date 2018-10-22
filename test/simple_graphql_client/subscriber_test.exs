defmodule SimpleGraphqlClientTest.Subscriber do
  use ExUnit.Case
  alias SimpleGraphqlClient.Subscriber

  @named_qurey """
  subscription coolName {
    quizFinish{
      timeBonus
    }
  }
  """
  @nameless_query """
  subscription {
    quizFinish{
      timeBonus
    }
  }
  """

  describe "get_subscription_name" do
    test "returns name from properly formated sub" do
      assert Subscriber.get_subscription_name(@named_qurey) == "coolName"
    end

    test "it does no fail with nameless query" do
      assert is_binary(Subscriber.get_subscription_name(@nameless_query))
    end
  end
end
