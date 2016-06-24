defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  def simple_test_data do
    [[c1: "r1 c1", c2: "r1 c2", c3: "r1 c3", c4: "r1+++c4"],
     [c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2 c4"],
     [c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3 c4"],
     [c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 c4"]]
   end

   def headers, do: [:c1, :c2, :c4]

   def split_with_three_cols do
     TF.split_into_cols(simple_test_data, headers)
   end

  test "split_into_cols" do
    cols = split_with_three_cols
    assert length(cols) == length(headers)
    assert List.first(cols) == ["r1 c1", "r2 c1", "r3 c1", "r4 c1"]
    assert List.last(cols) == ["r1+++c4", "r2 c4", "r3 c4", "r4 c4"]
  end

  test "col_widths" do
    widths = TF.widths_of(split_with_three_cols)
    assert widths = [5,6,7]
  end

  test "correct format string returned" do
    assert TF.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
  end

  test "Output is correct" do
    result = capture_io fn ->
      TF.print_table_for_cols(simple_test_data, headers)
    end
    assert result == """
    c1    | c2     | c4     
    ------+--------+--------
    r1 c1 | r1 c2  | r1+++c4
    r2 c1 | r2 c2  | r2 c4  
    r3 c1 | r3 c2  | r3 c4  
    r4 c1 | r4++c2 | r4 c4  
    """
  end
end

