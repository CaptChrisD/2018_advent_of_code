defmodule Day1.Part1 do

  def process([]), do: 0
  def process(""), do: 0
  def process(list), do: do_process(list, 0)

  defp do_process([], acc), do: acc
  defp do_process(["" | t], acc), do: do_process(t, acc)
  defp do_process([h | t], acc) do
    sum =
      h
      |> Integer.parse
      |> elem(0)
      |> Kernel.+(acc)
    do_process(t, sum)
  end
end

defmodule Day1.Part2 do

  def process([]), do: 0
  def process(""), do: 0
  def process(list), do: do_process(list, list, 0, MapSet.new([0]))

  defp do_process([], org, acc, history), do: do_process(org, org, acc, history)
  defp do_process(["" | t], org, acc, history), do: do_process(t, org, acc, history)
  defp do_process([h | t], org, acc, history) do
    sum =
      h
      |> Integer.parse
      |> elem(0)
      |> Kernel.+(acc)
    case MapSet.member?(history, sum) do
      true -> sum
      false -> do_process(t, org, sum, MapSet.put(history, sum))
    end
  end
end

ExUnit.start()

defmodule Day1Test do
  use ExUnit.Case

  import Day1.Part1

  test "part 1 - regular cases" do
    assert Day1.Part1.process(["1"]) == 1
    assert Day1.Part1.process(["1","2"]) == 3
    assert Day1.Part1.process(["-5", "2"]) == -3
    assert Day1.Part1.process(["-5", "", "2"]) == -3
  end

  test "part 1 - provided data" do
    list =
      "input.txt"
      |> File.read
      |> elem(1)
      |> String.split("\n")
    assert Day1.Part1.process(list) == 538
  end

  test "part 2 - regular test" do
    assert Day1.Part2.process(["+1", "-1"]) == 0
    assert Day1.Part2.process(["+3", "+3", "+4", "-2", "-4"]) == 10
    assert Day1.Part2.process(["-6", "+3", "+8", "+5", "-6"]) == 5
    assert Day1.Part2.process(["+7", "+7", "-2", "-7", "-4"]) == 14
  end

  test "part 2 - provided data" do
    list =
      "input.txt"
      |> File.read
      |> elem(1)
      |> String.split("\n")
    assert Day1.Part2.process(list) == 77271
  end
end

