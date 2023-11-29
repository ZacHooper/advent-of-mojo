from algorithm import sort
from helpers import text, vectors

fn main():
    let input: String
    try:
        with open("inputs/day1_input.txt", "r") as f:
            input = f.read()
    except IOError:
        print("File not found")
        return

    let sep: String = "\n\n"

    let stripped_input = text.strip_string(input)
    
    let elves = text.split_string(stripped_input, sep)
    var calories = DynamicVector[Int]()
    for i in range(len(elves)):
        var elf_calories: Int = 0
        let stripped_elf = text.strip_string(elves[i])
        let int_elf = text.split_string(stripped_elf, "\n")
        for j in range(len(int_elf)):
            try:
                let int_calories = atol(int_elf[j])
                elf_calories += int_calories
            except ValueError:
                print("Couldn't convert to int: " + String(int_elf[j]))
                return
        calories.push_back(elf_calories)
    
    let max_elf = vectors.max_index(calories)
    print("Elf " + String(max_elf) + " ate the most calories: " + String(calories[max_elf]))
    sort.sort(calories)
    let first_max_elf = calories[len(calories)-1]
    let second_max_elf = calories[len(calories)-2]
    let third_max_elf = calories[len(calories)-3]
    print("The first elf ate " + String(first_max_elf) + " calories")
    print("The second elf ate " + String(second_max_elf) + " calories")
    print("The third elf ate " + String(third_max_elf) + " calories")
    print("The top three elves ate " + String(first_max_elf + second_max_elf + third_max_elf) + " calories")
    