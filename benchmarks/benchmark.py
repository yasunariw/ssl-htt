import subprocess
from time import perf_counter
from os import listdir
from os.path import isfile, join
import sys
import csv


BENCHMARK_DIR    = "advanced"
BENCHMARK_GROUPS = ["bst", "dll", "srtl"]
STAT_FILE        = "advanced-HTT.csv"


def coqwc(fpath, cwd):
	res = subprocess.run(["coqwc", fpath], cwd=cwd, text=True, capture_output=True)
	if res.returncode != 0:
		return None
	try:
		line = res.stdout.split("\n")[1].split()
		return (line[0], line[1])
	except e:
		print(e)
		return None


def coqc(fpath, cwd):
	t1 = perf_counter()
	code = subprocess.call(["make", fpath], cwd=cwd)
	t2 = perf_counter()

	if code == 0:
		d = t2 - t1
		return f"{d:.1f}"
	else:
		return None


def main():
	with open(STAT_FILE, "w", newline="") as csvfile:
		writer = csv.writer(csvfile)
		header = ["Benchmark Group", "File Name", "Spec Size", "Proof Size", "Proof Checking Time (sec)"]
		writer.writerow(header)

		for group in BENCHMARK_GROUPS:
			cwd = join(BENCHMARK_DIR, group)
			files = [f for f in listdir(cwd) if isfile(join(cwd, f))]

			print("=========================================")
			print(f"  Benchmark Group: {group}")
			print("=========================================\n")

			# compile common defs
			print(f"Compiling common definitions for benchmark group '{group}'...", end="")
			if "common.v" not in files:
				print(f"- ERR\n  Common definitions not found for benchmark group '{group}'.")
				continue
			if coqc("common", cwd) is None:
				print(f"- ERR\n  Failed to compile common definitions for benchmark group '{group}'.")
				continue
			print("done!")

			for f in files:
				if f == "common.v" or not f.endswith(".v"):
					continue

				print(f"Checking sizes for {f}...", end="")
				sizes = coqwc(f, cwd)
				if sizes is None:
					print(f"- ERR\n  Failed to check sizes for {f}.")
					duration = None
				else:
					print("done!")
					print(f"Compiling {f}...", end="")
					duration = coqc(f+"o", cwd)
					if duration is None:
						print(f"- ERR\n  Failed to compile {f}.")
					else:
						print("done!")

				row = [group, f, sizes[0], sizes[1], duration]
				rowstr = list(map(lambda x: "-" if x is None else str(x), row))

				writer.writerow(rowstr)
				csvfile.flush()

			print("\n")

if __name__ == '__main__':
	main()
