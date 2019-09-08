defmodule Proj1.Worker do
  use GenServer

  #############################################################################
  #                                   API                                     #
  #############################################################################


  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(name))
  end


  def solve_range(worker_name, range) do
    GenServer.cast(via_tuple(worker_name), {:solve_range, range})
  end


  def get_solutions(worker_name) do
    GenServer.call(via_tuple(worker_name), :get_solutions)
  end


  defp via_tuple(worker_name) do
    {:via, Proj1.Registry, {:vampire_worker, worker_name}}
  end


  #############################################################################
  #                                   SERVER                                     #
  #############################################################################


  def init(messages) do
    {:ok, messages}
  end


  # Find all the vampire numbers in a given range
  def handle_cast({:solve_range, range}, vampire_numbers) do
      {:noreply, [find_vampire_numbers(range) | vampire_numbers]}
   end


   # Return all the vampire numbers found
   def handle_call(:get_solutions, _from, vampire_numbers) do
     {:reply, vampire_numbers, []}
   end


  #############################################################################
  #                              Helper Functions                             #
  #############################################################################


  def find_vampire_numbers(range) do
    range
    |> Enum.reduce(
      fn current_number, vampire_numbers ->
        res = ranged_search(current_number)
        if ! Enum.empty?(res) do
          [[current_number | res] | vampire_numbers] # Number is a vampire number
        else
          vampire_numbers
        end
      end
    )
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
