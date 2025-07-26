import os
import sys

# success = 0
success = "SUCCESS"
# fail = 1 
fail = "FAILURE"
# incomplete = 2
incomplete = "INCOMPLETE"

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
axioms = "search-report-axioms-"
dilemma = "search-report-dilemma-"

def read_results(full):
    read = lambda x: open(x, "r").read().split("\n")
    for file in os.listdir(full):
        if file.endswith("-proofs.txt"):
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
        if elem.startswith(without) or elem.startswith(without_fixed) or elem.startswith(withs) or elem.startswith(axioms) or elem.startswith(dilemma):
            full = os.path.join(test,elem)
            r[elem] = str_status(read_results(full))
    for label in sorted(r.keys()):
        print(f"    {label} = {r[label]}")

def analyze(test,label):
    r = {}
    for elem in os.listdir(test):
        if elem.startswith(without) or elem.startswith(without_fixed) or elem.startswith(withs) or elem.startswith(axioms) or elem.startswith(dilemma):
            full = os.path.join(test,elem)
            r[elem] = read_results(full)
    if without not in r:
        print(f"--> {label} INCOMPLETE <--")
    elif r[without] == 0:
        print(f"{label} provable without lemmas")
    else:
        print(f"{label} not provable without lemmas")
        found = False
        for l in r:
            if l.startswith(dilemma) and not found:
                if r[l] == 0:
                    n = l.removeprefix(dilemma)
                    axi = f"search-report-axioms-axioms{n}"
                    axi1 = f"search-report-axioms-axioms{n}_1"
                    axi2 = f"search-report-axioms-axioms{n}_2"
                    print(f"{label} provable with just {l}")
                    if axi in r:
                        if r[axi] == 0:
                            print(f"    {label} dilemma {l} provable")
                            found = True
                    elif axi1 in r and axi2 in r:
                        if r[axi1] == 0 and r[axi2] == 0 :
                            print(f"    {label} dilemma {l}_1 and {l}_2 provable")
                            found = True
                        elif r[axi1] == 0:
                            print(f"    {label} dilemma {l}_1 provable")
                            found = True
                        elif r[axi2] == 0 :
                            print(f"    {label} dilemma {l}_2 provable")
                            found = True
                    else:
                        print(f"    {label} misssing dilemma tests")
        if not found:
            for l in r:
                if l.startswith(withs) and not found:
                    if r[l] == 0:
                        print(f"{label} provable with lemmas ({l})")
                        found = True


lfind_tests = [
        "goal50_3", "goal41_3", "goal49_2", "goal62_2", "goal42", "goal49_1",
        "goal62_1", "goal47_1", "goal50_1", "goal69_1", "goal41_1", "goal44",
        "goal47_2", "goal50_2", "goal14", "goal41_2", "goal69_2", "goal49_3",
        "leftist_mergea_by_rank_right_height_5", "leftist_mergea_by_rank_right_height_1",
        "leftist_merge_by_leftist_mergea", "leftist_mergea_by_rank_right_height_6",
        "leftist_mergea_by_rank_right_height_2", "leftist_hinsert_by_leftist_merge",
        "leftist_mergea_by_rank_right_height_3","leftist_mergea_by_rank_right_height_4",
        "leftist_hinsert_mulit_by_leftist_hinsert"
    ]

ran = [
    "cons_of_small_maintains_sort_ind_length_by_le_all__le_one",
    "cons_of_small_maintains_sort_ind_length_by_select_in",
    "cons_of_small_maintains_sort_ind_length_by_select_rest_length",
    "cons_of_small_maintains_sort_ind_length_by_select_smallest",
    "cons_of_small_maintains_sort_ind_list_by_Permutation_in",
    "cons_of_small_maintains_sort_ind_list_by_le_all__le_one",
    "cons_of_small_maintains_sort_ind_list_by_selsort_perm",
    "le_all__le_one_by_Forall_forall",
    "select_in_by_Permutation_in",
    "select_in_by_select_perm",
    "select_rest_length_by_Permutation_length",
    "select_rest_length_by_select_perm",
    "selection_sort_is_correct_by_selection_sort_sorted",
    "selection_sort_sorted_by_selsort_sorted",
    "selsort_perm_by_select_rest_length",
    "selsort_sorted_by_select_rest_length_1",
    "selsort_sorted_by_select_rest_length_2",
    "selsort_sorted_by_select_smallest"
]

if sys.argv[1] != "all":
    full_test = sys.argv[1]
    driver(full_test)
else:
    prover = "/home/proverbot/prover-tests/"
    lfind_benches = "/home/proverbot/prover-tests/lfind_benches"
    for label in ran:
        test = os.path.join(prover,label)
        analyze(test,label)