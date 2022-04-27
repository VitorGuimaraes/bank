defmodule NewBankTest do
  use ExUnit.Case
  doctest NewBank

  test "greets the world" do
    assert NewBank.hello() == :world
  end
end
