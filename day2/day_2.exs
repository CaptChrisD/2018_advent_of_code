defmodule Day2 do
  defmodule Part1 do

    # horrible perf solution... O(2n)
    def checksum([], two, three), do: two * three
    def checksum([h | t], two, three) do
      counts =
        h
        |> String.codepoints
        |> Enum.map_reduce(%{}, fn(i, acc) ->
          case Map.fetch(acc, i) do
            :error -> {i, Map.put(acc, i, 1)}
            {:ok, val} ->
              {i, Map.put(acc, i, val + 1)}
          end
        end)
        |> elem(1)
        |> Enum.map_reduce(%{two: two, three: three},
          fn
            {_k, 2}, acc -> {nil, Map.put(acc, :two, two + 1)}
            {_k, 3}, acc -> {nil, Map.put(acc, :three, three + 1)}
            {_k, _v}, acc -> {nil, acc}
          end
        )
        |> elem(1)

      checksum(t, Map.get(counts, :two), Map.get(counts, :three))
    end
  end

  defmodule Part2 do

    def almost_matching([]), do: nil
    def almost_matching([h | t]) do
      if off_by_one = off_by_one(h, t) do
        {id1, id2} = off_by_one
          id1
          |> String.myers_difference(id2)
          |> Enum.filter(fn({k, _v}) -> k == :eq end)
          |> Enum.map(fn({_k, v}) -> v end)
          |> Enum.join("")
      else
        almost_matching(t)
      end
    end

    def off_by_one(_test, []), do: nil
    def off_by_one(test, [h | t]) do
      test
      |> String.myers_difference(h)
      |> Enum.reduce_while(0, fn({k, v}, acc) ->
        cond do
          k == :del && String.length(v) == 1 ->
            {:cont, acc + 1}
          k == :del ->
            {:halt, :error}
          true ->
            {:cont, acc}
        end
      end)
      |> case do
        1 -> {test, h}
        _ -> off_by_one(test, t)
      end
    end
  end
end

ExUnit.start()

defmodule Day2Part1Test do
  use ExUnit.Case

  test "part 1 - checksum test" do
    assert Day2.Part1.checksum(["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"], 0, 0) == 12
  end

  test "part 1 - provided data" do
    list =
      "input.txt"
      |> File.read
      |> elem(1)
      |> String.split("\n")
    assert Day2.Part1.checksum(list, 0, 0) == 6474
  end

  test "part 2 - diff test" do
    assert Day2.Part2.almost_matching(["abcde","fghij","klmno","pqrst","fguij","axcye","wvxyz"]) == "fgij"
  end

  test "part 2 - provided test" do
    list =
      "input.txt"
      |> File.read
      |> elem(1)
      |> String.split("\n")
    assert Day2.Part2.almost_matching(list) == "mxhwoglxgeauywfkztndcvjqr"
  end
end

