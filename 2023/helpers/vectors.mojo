from utils.vector import InlinedFixedVector


fn max_index(calories: DynamicVector[Int]) -> Int:
    var max_calories = 0
    var max_elf = 0
    for i in range(len(calories)):
        if calories[i] > max_calories:
            max_calories = calories[i]
            max_elf = i
    return max_elf


fn contains[width: Int](vec: InlinedFixedVector[Int, width], val: Int) -> Bool:
    for i in range(len(vec)):
        if vec[i] == val:
            return True
    return False
