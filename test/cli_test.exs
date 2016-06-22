defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(~w(-h anything)) == :help
    assert parse_args(~w(--help anything)) == :help
  end

  test "three values returned if three given" do
    assert parse_args(~w(user project 99)) == {"user", "project", 99}
  end

  test "count is default if two values given" do
    assert parse_args(~w(user project)) == {"user", "project", 4}
  end
end
