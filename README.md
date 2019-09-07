# distributed-systems

## Features
There are a couple important features of our software.

- 1) The normal version assumes 3 Cores are provided, as that's what
     we've setup our VM to run with. This version outputs all the vampire numbers and their fangs
     in the range of (starting_number to ending_number) This can be run via:

     $ cd proj1
     $ mix run proj1.exs <starting_number> <ending_number>

- 2) However, we've also provided a better more dynamic version. By adding a 3rd
     argument to the command our program allows you to control how many processes
     are spawned to handle the computation. It works as follows:

     $ cd proj1
     $ mix run proj1-better.exs <starting_number> <ending_number> <number_of_cores>

     **Note** proj1-better.exs does find the vampire numbers, however it does
     not output them. It does this to not clutter the terminal with output.

     **Note** Included is a bash script "execution-test" which will output the different
     timings of running the above mix command with 1 - 10 processes. Run this via:

     $ cd proj1 # (Do this if your are not already in the proj1 directory)
     $ chmod +x ./execution-test # (This only has to be run if the execution-test file is not executable)
     $ ./execution-test
