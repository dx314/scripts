import os
import time
from collections import defaultdict
from pathlib import Path

file_directory = "/home/ubuntu/backups/db"
date_format = "%Y-%m-%d"
time_format = "%H:%M:%S"

def get_creation_date_time(file_path):
    timestamp = os.path.getctime(file_path)
    return time.strftime(date_format, time.localtime(timestamp)), time.strftime(time_format, time.localtime(timestamp))

def keep_closest_to_noon_and_latest(files):
    files_by_date = defaultdict(list)

    for file in files:
        creation_date, creation_time = get_creation_date_time(file)
        files_by_date[creation_date].append((file, creation_time))

    for date, files in files_by_date.items():
        if len(files) > 2:
            noon_file, latest_file = None, None
            min_diff_to_noon, max_time = float('inf'), "00:00:00"

            for file, creation_time in files:
                current_time = [int(t) for t in creation_time.split(':')]
                noon_diff = abs((current_time[0] * 3600 + current_time[1] * 60 + current_time[2]) - (12 * 3600))

                if noon_diff < min_diff_to_noon:
                    min_diff_to_noon = noon_diff
                    noon_file = file

                if creation_time > max_time:
                    max_time = creation_time
                    latest_file = file

            for file, _ in files:
                if file != noon_file and file != latest_file:
                    os.remove(file)
                    print(f"Deleted {file}")

def main():
    os.chdir(file_directory)

    files = [str(file) for file in Path(file_directory).glob("*") if file.is_file()]
    keep_closest_to_noon_and_latest(files)

    print("Finished sorting and keeping one file closest to 12 PM and one file from the end of the day based on creation date.")

if __name__ == "__main__":
    main()
