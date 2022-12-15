pairs = String.split(String.trim(File.read!("input.txt"), "\n"), "\n\n")

defmodule Part1 do
  def compare_entries(pair, pairs) when pair < length(pairs) do
    [packet1, packet2] = String.split(Enum.at(pairs, pair), "\n")
    packet1 = Jason.decode!(packet1)
    packet2 = Jason.decode!(packet2)
    {_, result} = compare_packets(packet1, packet2)
    if (result) do
      pair + 1 + compare_entries(pair + 1, pairs)
    else
      compare_entries(pair + 1, pairs)
    end
  end

  def compare_entries(pair, pairs) do
    0
  end

  def compare_packets(packet1, packet2) when is_nil(packet1) and is_nil(packet2) do
    {false, true}
    IO.puts("undefined")
  end

  def compare_packets(packet1, packet2) when is_nil(packet1) or is_nil(packet2) do
    {true, is_nil(packet1)}
  end

  def compare_packets(packet1, packet2) when is_number(packet1) and is_number(packet2) do
    {packet1 != packet2, packet1 < packet2}
  end
  
  def compare_packets(packet1, packet2) when is_number(packet1) != is_number(packet2) do
    if (is_number(packet1)) do
      compare_packets([packet1], packet2)
    else
      compare_packets(packet1, [packet2])
    end
  end
 
  def compare_packets(packet1, packet2) when is_list(packet1) and is_list(packet2) do
    compare_packets_loop(packet1, packet2, 0)
  end

  def compare_packets_loop(packet1, packet2, index) when length(packet1) > index and length(packet2) > index do
    x = compare_packets(Enum.at(packet1, index), Enum.at(packet2, index))
    {success, value} = x
    if (success) do
      {true, value}
    else
      compare_packets_loop(packet1, packet2, index + 1)
    end  
  end

  def compare_packets_loop(packet1, packet2, index) do
    {length(packet1) != length(packet2), length(packet1) <= length(packet2)}
  end
end
IO.puts(Part1.compare_entries(0, pairs))
