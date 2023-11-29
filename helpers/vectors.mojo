fn max_index(calories: DynamicVector[Int]) -> Int:
    var max_calories = 0
    var max_elf = 0
    for i in range(len(calories)):
        if calories[i] > max_calories:
            max_calories = calories[i]
            max_elf = i
    return max_elf