from math import math
from helpers import text

fn any(borrowed input: StringRef, borrowed search: StringRef) -> Bool:
    for i in range(0, len(input)):
        if input[i] == search:
            return True
    return False
    # let has_search = input.find(search)
    # if has_search != -1:
    #     return True
    # else:
    #     return False

fn get_priority(borrowed input: StringRef) -> Int:
    let priorities: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    return priorities.find(input) + 1

fn main() raises:
    let input: String
    with open("inputs/day3_input.txt", "r") as f:
        input = f.read()
    
    let rugsacks: DynamicVector[StringRef] = text.split_string(input, "\n")

    var total_priority = 0
    
    for rugsack_idx in range(0, len(rugsacks), 3):
        
        let rugsack_1 = rugsacks[rugsack_idx]
        let rugsack_2 = rugsacks[rugsack_idx + 1]
        let rugsack_3 = rugsacks[rugsack_idx + 2]

        # print(rugsack_1, rugsack_2, rugsack_3)
        
        # Part 1
        # let rugsack_len = len(rugsack_1)
        # # Separate the string into each compartment
        # let mid_point = math.floor(rugsack_len/2).to_int()
        # let comp1 = String(rugsack_1)[0:mid_point]
        # let comp2 = String(rugsack_1)[mid_point:rugsack_len]
        
        # print(len(comp1), len(comp2), rugsack_len)

        # for i in range(0, len(comp1)):
        #     let has_char = any(comp2, comp1[i])
        #     if has_char == True:
        #         print("Found a match! " + comp1[i] + " with priority " + get_priority(comp1[i]))
        #         total_priority += get_priority(comp1[i])
        #         break

        # Part 2 - Find the match car in the other two rugsacks
        let rugsack_len = len(rugsack_1)
        for i in range(len(rugsack_1)):
            let has_char = any(rugsack_2, rugsack_1[i])
            let has_char2 = any(rugsack_3, rugsack_1[i])
            if has_char == True and has_char2 == True:
                # print("Found a match! " + rugsack_1[i] + " with priority " + get_priority(rugsack_1[i]))
                total_priority += get_priority(rugsack_1[i])
                break
    
    print("Total priority: " + String(total_priority))