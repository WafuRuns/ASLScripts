from datetime import datetime
from datetime import timedelta

file = open("00000.txt", "r")
pattern = "%M:%S.%f"
loading_time = timedelta(0, 0, 0)

for line in file:
    line_split = line.split(" - ")
    time_start = datetime.strptime(line_split[0].strip(), pattern)
    time_end = datetime.strptime(line_split[1].strip(), pattern)
    delta = (time_end - time_start)
    loading_time += delta

print(loading_time)
