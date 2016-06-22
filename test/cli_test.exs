defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [
    parse_args: 1,
    sort_into_ascending_order: 1,
    convert_to_list_of_maps: 1
  ]

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

  test "sort ascending orders the correct way" do
    issues = ~w(c a b)
    |> fake_create_at_list
    |> sort_into_ascending_order
    |> Enum.map(&(&1["created_at"]))
    assert issues == ~w(a b c)
  end

  defp fake_create_at_list(values) do
    data = for value <- values, do: [{"created_at", value}, {"other_data", "xxx"}]
    convert_to_list_of_maps data
  end
end
