from helpers import text


fn is_digit(char: String) raises -> Bool:
    for i in range(10):
        if char == atol(i):
            return True
    return False

fn string_to_num(number: String) raises -> Int:
    if number == "1" or number == "one":
        return 1
    elif number == "2" or number == "two":
        return 2
    elif number == "3" or number == "three":
        return 3
    elif number == "4" or number == "four":
        return 4
    elif number == "5" or number == "five":
        return 5
    elif number == "6" or number == "six":
        return 6
    elif number == "7" or number == "seven":
        return 7
    elif number == "8" or number == "eight":
        return 8
    elif number == "9" or number == "nine":
        return 9
    else:
        return 0

fn reverse_string(input: String) raises -> String:
    var output: String = ""
    for i in range(len(input)):
        output += input[len(input) - i - 1]
    return output

fn find_number(calibration: String, reverse: Bool = False) raises -> Int:
    let numbers = StaticTuple[18](
        "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
        "1", "2", "3", "4", "5", "6", "7", "8", "9"
    )
    let index_range = range(18)
    var first_digit: Int = 0
    var second_digit: Int = 0
    var earliest_index: Int = -1
    var latest_index: Int = -1
    var search_index: Int = -1

    for i in index_range:
        search_index = calibration.find(numbers[i])
        if search_index != -1:
            if earliest_index == -1:
                earliest_index = search_index
                latest_index = search_index
                first_digit = string_to_num(numbers[i])
                second_digit = string_to_num(numbers[i])
            elif search_index < earliest_index:
                earliest_index = search_index
                first_digit = string_to_num(numbers[i])
            elif search_index > latest_index:
                latest_index = search_index
                second_digit = string_to_num(numbers[i])

    if reverse:
        return second_digit
    else:
        return first_digit




fn main() raises:
    let input: String
    with open("inputs/day1/day1_input.txt", "r") as f:
        input = f.read()
    
    let codes = text.split_string(input, "\n")

    var total_codes = 0
    for i in range(len(codes)):
        let calibration = codes[i]
        var first_digit: Int = 0
        var second_digit: Int = 0

        for j in range(len(calibration)):
            let window = String(calibration)[j:j+5]
            first_digit = find_number(window)
            if first_digit != 0:
                break
        # Scan thourgh calibration again, but this time in reverse
        for j in range(len(calibration), 0, -1):
            var window_size = 5
            if len(calibration) < 5:
                window_size = len(calibration)
            let window = String(calibration)[j-window_size:j]
            second_digit = find_number(window, True)
            if is_digit(window[len(window) - 1]):
                second_digit = atol(window[len(window) - 1])
            if second_digit != 0:
                break


        if second_digit == 0:
            second_digit = first_digit
        let code = String(first_digit) + String(second_digit)
        print(code + " -> " + calibration)
        total_codes += atol(code)
    
    print(total_codes)
    
    






