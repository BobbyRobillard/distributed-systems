defmodule VampireNumbers do

  def loop do
    receive do
      {sender_pid, number} ->
        send(sender_pid, {:ok, ranged_search(number)})
       _ -> IO.puts("Good job, ya done f***** up...")
    end
  end

  def ranged_search(number) do
    digits = Integer.digits(number)
    divisor = trunc(:math.pow(10, length(digits) - 2))
    ranged_search(number, digits, divisor, 0, 0, [])
  end

  def ranged_search(number, digits, divisor, x, y, acc) do
    cond do
      divisor == 0 -> if x * y == number and (rem(x, 10) != 0 or rem(y, 10) != 0) do [x, y] ++ acc else acc end
      true ->
        x = 10 * x
        y = 10 * y
        target = trunc(number / divisor)
        minXd = max(0, trunc(target / (y + 10) - x))
        maxXd = if y != 0 do min(9, trunc((target + 1) / y - x)) else 9 end
        ranged_search_x(number, digits, divisor, x, y, target, minXd, maxXd, acc)
    end
  end

  def ranged_search_x(number, digits, divisor, x, y, target, minXd, xd, acc) do
    cond do
      xd < minXd -> acc
      !Enum.member?(digits, xd) -> ranged_search_x(number, digits, divisor, x, y, target, minXd, xd - 1, acc)
      true ->
        rootX = x + xd
        minYd = max(if x == y do xd else 0 end, trunc(target / (rootX + 1) - y))
        maxYd = if rootX != 0 do min(9, trunc((target + 1) / rootX - y)) else 9 end
        search = ranged_search_y(number, List.delete(digits, xd), divisor, rootX, y, target, minYd, maxYd, acc)
        ranged_search_x(number, digits, divisor, x, y, target, minXd, xd - 1, search)
    end
  end

  def ranged_search_y(number, digits, divisor, x, y, target, yd, maxYd, acc) do
    cond do
      yd > maxYd -> acc
      !Enum.member?(digits, yd) -> ranged_search_y(number, digits, divisor, x, y, target, yd + 1, maxYd, acc)
      true ->
        search = ranged_search(number, List.delete(digits, yd), trunc(divisor / 100), x, y + yd, acc)
        ranged_search_y(number, digits, divisor, x, y, target, yd + 1, maxYd, search)
    end
  end

end

# [lower, upper] = Enum.map(System.argv, &String.to_integer/1)
# Enum.each(lower..upper, fn number ->
#   case VampireNumbers.ranged_search(number) do
#     [] -> nil
#     fangs -> IO.puts([Integer.to_string(number), " ", Enum.join(fangs, " ")])
#   end
# end)
#
[lower, upper] = Enum.map(System.argv, &String.to_integer/1)
Enum.each(lower..upper, fn number ->
  pid = spawn(VampireNumbers, :loop, [])
  send(pid, {self, number})
  # case VampireNumbers.ranged_search(number) do
  #   [] -> nil
  #   fangs -> IO.puts([Integer.to_string(number), " ", Enum.join(fangs, " ")])
  # end
end)
