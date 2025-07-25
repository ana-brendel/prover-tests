import os

def cmd(test,axiom):
    folder = f"/home/proverbot/prover-tests/{test}"
    a = f"--add-axioms={folder}/axioms{axiom}.txt" if axiom > 0 else (f"--add-axioms={folder}/axioms.txt" if axiom == 0 else "")
    label = ("without" if axiom < 0 else "without-fixed") if axiom <= 0 else f"with-{axiom}"
    c = f"python3 /home/proverbot/src/search_file.py --prelude={folder} --weightsfile=/home/proverbot/data/polyarg-weights.dat {folder}/source.v {a} --no-generate-report --max-proof-time=15 -P -o {folder}/search-report-{label}"
    return c

def axiom_command(test,axiom_label):
    folder = f"/home/proverbot/prover-tests/{test}"
    a = f"--add-axioms={folder}/axioms.txt"
    label = f"axioms-{axiom_label}"
    c = f"python3 /home/proverbot/src/search_file.py --prelude={folder} --weightsfile=/home/proverbot/data/polyarg-weights.dat {folder}/{axiom_label}.v {a} --no-generate-report --max-proof-time=15 -P -o {folder}/search-report-{label}"
    return c

def dilemma_command(test,dilemma):
    folder = f"/home/proverbot/prover-tests/{test}"
    a = f"--add-axioms={folder}/dilemma{dilemma}.txt"
    label = f"dilemma-{dilemma}"
    c = f"python3 /home/proverbot/src/search_file.py --prelude={folder} --weightsfile=/home/proverbot/data/polyarg-weights.dat {folder}/source.v {a} --no-generate-report --max-proof-time=15 -P -o {folder}/search-report-{label}"
    return c

test_results = {
    "select_rest_length_by_select_perm" : [1,2,3],
    "selsort_sorted_by_select_rest_length_1" : [1,2,3,4,5],
    "selsort_perm_by_select_perm" : [1,2,3,4,5],
    "selection_sort_is_correct_by_selection_sort_sorted" : [1,2,3],
    "selsort_perm_by_select_rest_length" : [1,2,3],
    "cons_of_small_maintains_sort_ind_length_by_select_smallest" : [1,2,3,4,5],
    "selection_sort_perm_by_selsort_perm" : [1,2,3,4,5],
    "selsort_sorted_by_select_smallest" : [1,2,3,4,5],
    "select_smallest_by_select_fst_leq_1" : [1,2,3,4,5],
    "selsort_sorted_by_select_rest_length_2" : [1,2,3,4,5],
    "selsort_sorted_by_cons_of_small_maintains_sort" : [1,2,3,4,5],
    "select_in_by_select_perm" : [1,2,3,4,5],
    "cons_of_small_maintains_sort_ind_length_by_le_all__le_one" : [1],
    "cons_of_small_maintains_sort_ind_list_by_selsort_perm" : [1,2,3,4,5],
    "selection_sort_is_correct_by_selection_sort_perm" : [1,2,3,4,5],
    "cons_of_small_maintains_sort_ind_length_by_select_in" : [1,2,3,4,5],
    "le_all__le_one_by_Forall_forall" : [1,2,3,4,5],
    "cons_of_small_maintains_sort_ind_list_by_Permutation_in" : [1,2,3,4,5],
    "cons_of_small_maintains_sort_ind_list_by_le_all__le_one" : [1,2,3,4,5],
    "select_rest_length_by_Permutation_length" : [1],
    "cons_of_small_maintains_sort_ind_length_by_select_rest_length" : [1,2,3],
    "select_in_by_Permutation_in" : [1,2],
    "selection_sort_sorted_by_selsort_sorted" : [1,2,3,4,5],
    "select_smallest_by_select_fst_leq_2" : [1,2,3,4,5]
}

to_run = [
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

# for test in test_results:
for test in to_run:
    os.system(cmd(test,-1))
    os.system(cmd(test,0))
    for i in test_results[test]:
        os.system(cmd(test,i))
        os.system(dilemma_command(test,i))
    full = f"/home/proverbot/prover-tests/{test}"
    results = os.path.join(full,"result_summary")
    for file in os.listdir(full):
        if file.endswith(".v") and file.startswith("axioms"):
            label = file.removesuffix(".v")
            os.system(axiom_command(test,label))
    os.system(f"python3 process.py {full} > {results}")

# print to terminal
for test in to_run:
    full = f"/home/proverbot/prover-tests/{test}"
    results = os.path.join(full,"result_summary")
    print("------------------------------------------------------------------------------")
    print(test)
    os.system(f"cat {results}")
    print("------------------------------------------------------------------------------")
    print()