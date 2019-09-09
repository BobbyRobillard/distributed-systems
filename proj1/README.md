# Project 1 Readme

**NOTE:** Please also see "Vampire-Numbers.md" for an explanation of how our vampire number finder works.

1) **Group Members**
 - Robert C. Robillard: 4987-1906
 - William B. Anderson: 6695-8353
 - To run our code $cd into the proj1 folder and run $ mix run proj1.exs <starting_number> <ending_number>

2) We used 3 worker actors, as that was all the cores I could afford to give my VM.

3) We give each worker a near equal portion of tasks. So for 3 workers each receives 1/3 of the work.
   **Note:** I say "near equal" because sometimes the range isn't exactly divisible by 3 and the last worker
   gets to slack off and do slightly less. We determined this by using Dobra's recommendation of "$ perf top"
   to check when more time was being spent in the Kernel (message passing). We deemed that having each worker
   complete all it's work then respond was the best approach given the timeframe to complete to project.

   **Note:** Had we had more time we would have taken a slightly different approach, and had each worker complete
   a smaller subset of work and report when finished, then take another subset. Thus making sure no worker was ever idle.
   But, unfortunately other classes and commitments are a thing, and the time it would take to create that solutions couldn't be spent currently.

4) Running "$ mix run proj1.exs 100000 200000" yields the following:
102510 201 510
104260 260 401
105210 210 501
105264 204 516
105750 150 705
108135 135 801
110758 158 701
115672 152 761
116725 161 725
117067 167 701
118440 141 840
120600 201 600
123354 231 534
124483 281 443
125248 152 824
125433 231 543
125460 204 615 246 510
125500 251 500
126027 201 627
126846 261 486
129640 140 926
129775 179 725
131242 311 422
132430 323 410
133245 315 423
134725 317 425
135828 231 588
135837 351 387
136525 215 635
136948 146 938
140350 350 401
145314 351 414
146137 317 461
146952 156 942
150300 300 501
152608 251 608
152685 261 585
153436 356 431
156240 240 651
156289 269 581
156915 165 951
162976 176 926
163944 396 414
172822 221 782
173250 231 750
174370 371 470
175329 231 759
180225 225 801
180297 201 897
182250 225 810
182650 281 650
186624 216 864
190260 210 906
192150 210 915
193257 327 591
193945 395 491
197725 275 719

5) The time run was obtained via "$ time mix run proj1.exs 100000 200000" and is:

- real    0m0.733s
- user    0m0.983s
- sys     0m0.168s

**Note:** Our vampire solving algorithm is very fast, to make real use of parallelism it's
best to run it with larger numbers. For instance, running "$ time mix run proj1.exs 1000 10000000" yields
the following:

- real    0m20.314s
- user    0m46.339s
- sys     0m0.418s

6) We solved up to 50,000,000. But could have solved much higher, we just didn't feel like wasting time playing
the waiting game.

7) We didn't use ":observer.start" and can't because we ran this on a headless VM.
