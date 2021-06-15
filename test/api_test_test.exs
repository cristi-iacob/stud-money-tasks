defmodule TaskManagementTest do
  use ExUnit.Case
  doctest TaskManagement

  test "greets the world" do
    assert TaskManagement.hello() == :world
  end
end
