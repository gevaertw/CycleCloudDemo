import sys
from datetime import datetime

start = int(sys.argv[1])
end = int(sys.argv[2])


for num in range(start, end + 1):
   if num > 1:
       for i in range(2, int(num**0.5) + 1):
           if (num % i) == 0:
               break
       else:
           print(num)


