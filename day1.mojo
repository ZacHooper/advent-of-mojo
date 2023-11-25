from algorithm import sort

fn split_string(input: String, sep: String) -> DynamicVector[StringRef]:
    let sep_len = len(sep)
    let input_len = len(input)
    var output: DynamicVector[StringRef] = DynamicVector[StringRef]()
    var start = 0
    var end = 0
    while end < input_len:
        let current_char = String(input)[end:end+sep_len]
        if current_char == sep:
            var upper_bound: Int = end
            if sep_len > 1:
                upper_bound += sep_len
            var sub_str = String(input)[start:upper_bound]
            let sub_point = sub_str._steal_ptr()
            output.push_back(StringRef(sub_point))
            start = end + sep_len
            end = start
        else:
            end += 1
    var sub_str = String(input)[start:end]
    let sub_point = sub_str._steal_ptr()
    output.push_back(StringRef(sub_point))
    return output

fn strip_string(input: String) -> String:
    let input_len = len(input)
    var start = 0
    var end = input_len
    while start < input_len:
        let current_char = String(input)[start:start+1]
        if current_char == " " or current_char == "\n" or current_char == "\t":
            start += 1
        else:
            break
    while end > 0:
        let current_char = String(input)[end-1:end]
        if current_char == " " or current_char == "\n" or current_char == "\t":
            end -= 1
        else:
            break
    return String(input)[start:end]

fn max_index(calories: DynamicVector[Int]) -> Int:
    var max_calories = 0
    var max_elf = 0
    for i in range(len(calories)):
        if calories[i] > max_calories:
            max_calories = calories[i]
            max_elf = i
    return max_elf

fn main():
    let input: String
    try:
        with open("day1_input.txt", "r") as f:
            input = f.read()
    except IOError:
        print("File not found")
        return

    let sep: String = "\n\n"

    let stripped_input = strip_string(input)
    
    let elves = split_string(stripped_input, sep)
    var calories = DynamicVector[Int]()
    for i in range(len(elves)):
        var elf_calories: Int = 0
        let stripped_elf = strip_string(elves[i])
        let int_elf = split_string(stripped_elf, "\n")
        for j in range(len(int_elf)):
            try:
                let int_calories = atol(int_elf[j])
                elf_calories += int_calories
            except ValueError:
                print("Couldn't convert to int: " + String(int_elf[j]))
                return
        calories.push_back(elf_calories)
    
    let max_elf = max_index(calories)
    print("Elf " + String(max_elf) + " ate the most calories: " + String(calories[max_elf]))
    sort.sort(calories)
    let first_max_elf = calories[len(calories)-1]
    let second_max_elf = calories[len(calories)-2]
    let third_max_elf = calories[len(calories)-3]
    print("The first elf ate " + String(first_max_elf) + " calories")
    print("The second elf ate " + String(second_max_elf) + " calories")
    print("The third elf ate " + String(third_max_elf) + " calories")
    print("The top three elves ate " + String(first_max_elf + second_max_elf + third_max_elf) + " calories")
    