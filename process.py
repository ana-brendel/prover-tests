import os
import sys

# success = 0
success = "{\"status\": \"SUCCESS\""
# fail = 1 
fail = "{\"status\": \"FAILURE\""
# incomplete = 2
incomplete = "{\"status\": \"INCOMPLETE\""

def str_status(stat):
    if stat == 2:
        return "INCOMPLETE"
    elif stat == 1:
        return "FAILURE"
    elif stat == 0:
        return "SUCCESS"
    else:
        return "ERROR"

without = "search-report-without"
without_fixed = "search-report-without-fixed"
withs = "search-report-with-"
axioms = "search-report-with-axioms-"

def read_results(full):
    read = lambda x: open(x, "r").read().split("\n")
    for file in os.listdir(full):
        if file.endswith("-proof.txt"):
            contents = read(os.path.join(full,file))
            for line in contents:
                if line.__contains__(incomplete):
                    return 2
                elif line.__contains__(fail):
                    return 1
                elif line.__contains__(success):
                    return 0
    return -1
            

def driver(test):
    r = {}
    for elem in os.listdir(test):
        if elem.startswith(without) or elem.startswith(without_fixed) or elem.startswith(withs) or elem.startswith(axioms):
            full = os.path.join(test,elem)
            r[elem] = str_status(read_results(full))
    for label in r:
        print(f"    {label} = {r[label]}")


full_test = sys.argv[1]
driver(full_test)