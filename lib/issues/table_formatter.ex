defmodule Issues.TableFormatter do
  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  def print_table_for_cols(rows, headers) do
    data_by_cols = split_into_cols(rows, headers)
    col_widths = widths_of(data_by_cols)
    format = format_for(col_widths)

    puts_one_line_in_cols(headers, format)
    IO.puts(separator(col_widths))
    puts_in_cols(data_by_cols, format)

  end

  def split_into_cols(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end
  
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(cols) do
    for col <- cols, do: col |> map(&String.length/1) |> max
  end

  def format_for(col_widths) do
    map_join(col_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(col_widths) do
    col_widths
    |> map_join("-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_cols(data_by_cols, format) do
    data_by_cols
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_cols(&1, format))
  end

  def puts_one_line_in_cols(fields, format) do
    :io.format(format, fields)
  end
end



