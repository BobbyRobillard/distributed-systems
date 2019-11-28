defmodule EngineTest do
  use ExUnit.Case

  setup do
    Proj4.Registry.start_link()
    Proj4.Supervisor.start_link()
    []
  end

  defp execute(command), do: Proj4.Engine.execute(String.split(command, " ", parts: 2))

  test "help" do
    assert {:ok, _} = execute("help")
  end

  test "register" do
    assert {:error, _} = execute("register")
  end

  test "register <username>" do
    assert {:ok, _} = execute("register user")
  end

  test "logon" do
    assert {:error, _} = execute("logon")
  end

  test "logon <username>" do
    assert {:ok, _} = execute("logon user")
  end

  test "logoff" do
    assert {:error, _} = execute("logoff")
  end

  test "logoff <username>" do
    assert {:ok, _} = execute("logoff user")
  end

  test "tweet" do
    assert {:error, _} = execute("tweet")
  end

  test "tweets" do
    assert {:error, _} = execute("tweets")
  end

  test "quit" do
    assert {:quit} = execute("quit")
  end

  test "invalid" do
    assert {:error, _} = execute("invalid")
  end

end
