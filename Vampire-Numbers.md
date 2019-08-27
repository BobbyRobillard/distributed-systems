# Vampire Numbers

Project 1: https://ufl.instructure.com/courses/379812/assignments/3984683

## Ranged Search Algorithm

Restricts the search values for x and y such that the range of products includes
the target value. Described by https://stackoverflow.com/a/36609331/11667368.

Can easily be converted to a distributed parallel algorithm by creating separate
actors to check intermediate combinations of x and y within the loops.

```java
public class VampireNumbers {

    private static final long[] EMPTY = new long[0];

    public static long[] rangedSearch(long number) {
        long divisor = 1; //10^digits
        int[] digits = new int[10]; //number of digits available (equal to index)
        for (long temp = number; temp > 0; temp /= 10) { //loop over all digits
            divisor *= 10; //multiply by 10 for each digit
            digits[(int) (temp % 10)]++; //increment count for digit
        }
        return rangedSearch(number, divisor / 100, digits,  0, 0); //recursive start
    }

    private static long[] rangedSearch(long number, long divisor, int[] digits, long x, long y) {
        if (divisor < 1) { //no more digits to append
            if (x * y == number && (x % 10 != 0 || y % 10 != 0)) { //valid vampire number
                return new long[] {x, y};
            } else {
                return EMPTY;
            }
        } else {
            long[] fangs = EMPTY;
            x *= 10; //prepare x for next digit
            y *= 10; //prepare y for next digit
            long target = number / divisor; //extract the target number for x * y
            int minXd = Math.max(0, (int) (target / (y + 10) - x)); //minimum x0 digit that can reach target
            int maxXd = y != 0 ? Math.min(9, (int) ((target + 1) / y - x)) : 9; //maximum x0 digit that can reach target
            for (int xd = minXd; xd <= maxXd; xd++) {
                if (digits[xd] == 0) continue; //continue if x0 digit is unavailable
                digits[xd]--; //consume x0 digit
                long rootX = x + xd; //root of x solution for this step
                int minYd = Math.max(x == y ? xd : 0, (int) (target / (rootX + 1) - y)); //minimum y0 digit that can reach target
                int maxYd = rootX != 0 ? Math.min(9, (int) ((target + 1) / rootX - y)) : 9; //maximum y0 digit that can reach target
                for (int yd = maxYd; yd >= minYd; yd--) { //iterate in reverse to ensure fangs are in order
                    if (digits[yd] == 0) continue; //continue if y0 digit is unavailable
                    digits[yd]--; //consume y0 digit
                    long[] result = rangedSearch(number, divisor / 100, digits, rootX, y + yd); //recursive call
                    if (result.length > 0) { //if fangs were found
                        if (fangs.length > 0) { //if there are current fangs, merge the results
                            long[] temp = new long[fangs.length + result.length];
                            System.arraycopy(fangs, 0, temp, 0, fangs.length);
                            System.arraycopy(result, 0, temp, fangs.length, result.length);
                            fangs = temp;
                        } else {
                            fangs = result;
                        }
                    }
                    digits[yd]++; //free y0 digit
                }
                digits[xd]++; //free x0 digit
            }
            return fangs;
        }
    }

}
```
