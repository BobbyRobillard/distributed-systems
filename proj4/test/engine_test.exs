defmodule EngineTest do
  use ExUnit.Case
  @moduletag :capture_log

  setup do
    Application.stop(:proj4)
    :ok = Application.start(:proj4)
    start_supervised!(Proj4.Registry)
    start_supervised!(Proj4.Supervisor)
    Agent.start_link(fn -> nil end, name: :active_user)
    execute("register user")
    []
  end

  defp execute(commands) do
    Enum.reduce(String.split(commands, ";"), nil, fn(command, _) ->
      Proj4.Engine.execute(command |> String.trim |> String.split(" ", parts: 2))
    end)
  end

  test "help" do
    assert {:ok, _} = execute("help")
  end

  test "register" do
    assert {:error, _} = execute("register")
    assert {:ok, _} = execute("register a")
    assert "a" = Agent.get(:active_user, fn u -> u end)
  end

  test "logon" do
    assert {:error, _} = execute("logon")
    assert {:ok, _} = execute("logon user")
  end

  test "logoff" do
    assert {:ok, _} = execute("logoff")
  end

  test "status" do
    assert {:ok, _} = execute("status")
    assert :online = Proj4.Node.get_status("user")
    assert {:ok, _} = execute("logoff")
    assert :offline = Proj4.Node.get_status("user")
  end

  test "follow" do
    assert {:ok, _} = execute("register a; logon a; follow a")
  end

  test "unfollow" do
    assert {:ok, _} = execute("unfollow a")
  end

  test "following" do
    assert {:ok, "a"} = execute("register a; logon user; follow a; following")
    assert {:ok, ""} = execute("logon a; following")
  end

  test "followers" do
    assert {:ok, ""} = execute("register a; logon user; follow a; followers")
    assert {:ok, "user"} = execute("logon a; followers")
  end

  test "tweet" do
    assert {:error, _} = execute("tweet")
    assert {:ok, _} = execute("tweet @trump #2020")
  end

  test "tweets" do
    assert {:ok, "@trump #2020"} = execute("tweet @trump #2020; tweets")
  end

  test "query" do
    assert {:error, _} = execute("query")
    assert {:ok, "@trump #2020"} = execute("tweet @trump #2020; query trump")
  end

  test "quit" do
    assert {:quit} = execute("quit")
  end

  test "invalid" do
    assert {:error, _} = execute("invalid")
  end

end
