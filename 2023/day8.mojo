from helpers.hash import HashTable
from helpers.vectors import StringDynamicVector

from math import lcm


fn left(key: String) -> String:
    """
    (BBB, CCC)
    return BBB.
    """
    return key[1:4]


fn right(key: String) -> String:
    """
    (BBB, CCC)
    return CCC.
    """
    return key[6:9]


fn get_index(input: String) -> String:
    """
    AAA = (BBB, CCC)
    return AAA.
    """
    return input[0:3]


fn get_map(input: String) -> String:
    """
    AAA = (BBB, CCC)
    return (BBB, CCC).
    """
    return input[6:]


fn get_next_root(
    root: String, direction: String, hash_table: HashTable
) raises -> String:
    """
    Given a root, directions, and a hash table, return the next root.
    """
    if direction == "L":
        return left(hash_table[root])
    elif direction == "R":
        return left(hash_table[root])
    return root


fn main() raises:
    let input: String
    let filename = "inputs/day8/input.txt"
    with open(filename, "r") as f:
        input = f.read()

    let sections = input.split("\n\n")
    let directions = sections[0]
    let nodes = sections[1].split("\n")

    # Build the hash table
    var hash_table = HashTable(100)
    for idx in range(len(nodes)):
        let key = get_index(nodes[idx])
        let value = get_map(nodes[idx])
        hash_table[key] = value

    # Step through the RL instructions. Loop around until we reach ZZZ.
    # PART 1
    # var root: String = "AAA"
    # var steps = 0
    # while root != "ZZZ":
    #     for idx in range(len(directions)):
    #         let node = hash_table[root]
    #         if directions[idx] == "L":
    #             root = left(node)
    #         elif directions[idx] == "R":
    #             root = right(node)
    #         steps += 1

    # print("Part 1: " + str(steps))

    # PART 2
    # Find the roots [GNA, FCA, AAA, MXA, VVA, XHA]
    var roots = StringDynamicVector[String]()
    for idx in range(len(nodes)):
        let key = get_index(nodes[idx])
        if key[2] == "A":
            roots.push_back(key)

    print(roots)

    var step_counts = DynamicVector[Int]()

    for i in range(roots.__len__()):
        print("Root: " + roots[i])
        var temp_count = 0
        var temp_root = roots[i]
        while temp_root[2] != "Z":
            for j in range(len(directions)):
                let node = hash_table[temp_root]
                if directions[j] == "L":
                    temp_root = left(node)
                elif directions[j] == "R":
                    temp_root = right(node)
                # temp_root = next_root
                temp_count += 1
        print("Count: " + str(temp_count))
        step_counts.push_back(temp_count)

    # With the step counts for each root we now need to find the LCM
    # of all of them.
    var lcm_steps = step_counts[0]
    for i in range(len(step_counts)):
        lcm_steps = lcm(lcm_steps, step_counts[i])

    # print("Part 2: " + str(step_counts))
    print("Part 2: " + str(lcm_steps))
