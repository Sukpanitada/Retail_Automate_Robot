list_A = [1, 2, 3, 5, 6, 8, 9]
list_B = [3, 2, 1, 5, 6, 0]

result = [item for item in list_A if item in list_B]

print(result)