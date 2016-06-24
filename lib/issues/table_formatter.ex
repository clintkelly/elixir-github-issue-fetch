defmodule Issues.TableFormatter do
  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  @doc """
  Takes a list of row data, where each row is a Map, and a list of headers.
  Prints a table to STDOUT of the data from each row identified by each header.
  That is, each header identifies a column, and those columns are extracted and
  printed from the rows.
  
  We calculate the width of each column to fit the longest element in that
  column.
  """
  def print_table_for_cols(rows, headers) do
    data_by_cols = split_into_cols(rows, headers)
    col_widths = widths_of(data_by_cols)
    format = format_for(col_widths)

    puts_one_line_in_cols(headers, format)
    IO.puts(separator(col_widths))
    puts_in_cols(data_by_cols, format)

  end

  @doc """
  Given a list of rows, where each row contains a keyed list of columns, return
  a list containing lists of the data in each column. The `headers` parameter
  contains the list of columns to extract.

  ## Example

      iex> list = [Enum.into([{"a", "1"}, {"b", "2"}, {"c", "3"}], %{}),
      ...>         Enum.into([{"a", "4"}, {"b", "5"}, {"c", "6"}], %{})]
      iex> Issues.TableFormatter.split_into_cols(list, ~w(a b c))
      [["1", "4"], ["2", "5"], ["3", "6"]]

  """
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



