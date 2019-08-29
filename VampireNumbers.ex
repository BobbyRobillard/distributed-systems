defmodule VampireNumbers do

  def ranged_search(number) do
    digits = Integer.digits(number)
    divisor = trunc(:math.pow(10, length(digits) - 2))
    ranged_search(number, digits, divisor, 0, 0)
  end

  def ranged_search(number, digits, divisor, x, y) do
    cond do
      divisor == 0 -> if x * y == number and (rem(x, 10) != 0 or rem(y, 10) != 0) do [x, y] else [] end
      true ->
        x = 10 * x
        y = 10 * y
        target = trunc(number / divisor)
        minXd = max(0, trunc(target / (y + 10) - x))
        maxXd = if y != 0 do min(9, trunc((target + 1) / y - x)) else 9 end
        ranged_search_x(number, digits, divisor, x, y, target, minXd, maxXd)
    end
  end

  def ranged_search_x(number, digits, divisor, x, y, target, xd, maxXd) do
    cond do
      xd > maxXd -> []
      !Enum.member?(digits, xd) -> ranged_search_x(number, digits, divisor, x, y, target, xd + 1, maxXd)
      true ->
        rootX = x + xd;
        minYd = max(if x == y do xd else 0 end, trunc(target / (rootX + 1) - y))
        maxYd = if rootX != 0 do min(9, trunc((target + 1) / rootX - y)) else 9 end
        search = ranged_search_y(number, List.delete(digits, xd), divisor, rootX, y, target, maxYd, minYd);
        search ++ ranged_search_x(number, digits, divisor, x, y, target, xd + 1, maxXd)
    end
  end

  def ranged_search_y(number, digits, divisor, x, y, target, yd, minYd) do
    cond do
      yd < minYd -> []
      !Enum.member?(digits, yd) -> ranged_search_y(number, digits, divisor, x, y, target, yd - 1, minYd)
      true ->
        search = ranged_search(number, List.delete(digits, yd), trunc(divisor / 100), x, y + yd)
        search ++ ranged_search_y(number, digits, divisor, x, y, target, yd - 1, minYd)
    end
  end

end
