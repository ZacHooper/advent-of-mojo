import testing


fn is_digit(char: String) -> Bool:
    let nums = "0123456789"
    for num in range(len(nums)):
        if char == num:
            return True
    return False


fn is_decimal(char: String) -> Bool:
    if char == ".":
        return True
    return False


fn is_symbol(char: String) -> Bool:
    let is_digit = is_digit(char)
    let is_decimal = is_decimal(char)
    if is_digit == False and is_decimal == False:
        return True
    return False


fn is_asterisk(char: String) -> Bool:
    if char == "*":
        return True
    return False

fn reverse_string(str: String) -> String:
    var reversed_str: String = ""
    for idx in range(len(str)):
        reversed_str += str[len(str) - idx - 1]
    return reversed_str

fn get_number(start_index: Int, end_index: Int, y_range: String) raises -> Int:
    var number: String = ""
    for idx in range(start_index, end_index + 1):
        if is_digit(y_range[idx]):
            number += y_range[idx]
        # Check if there is another number close to the one we want eg: 619.4... where we want 4
        # if this happens reset the number.
        if is_decimal(y_range[idx]) and end_index - idx > 1:
            number = ""

    
    return atol(number)

fn get_above_below_numbers(
    x_idx: Int, 
    digits_found: StaticTuple[3, Bool], 
    y_range: String[], 
    count_of_numbers_found: Int
) raises -> Int:
    """
    Get the actual numbers found above or below the current asterisk.
    """
    if count_of_numbers_found == 2:
        let left_number = get_number(x_idx - 3, x_idx, y_range)
        let right_number = get_number(x_idx + 1, x_idx + 3, y_range)
        return left_number * right_number
    if count_of_numbers_found == 1:
        if digits_found[0] == True and digits_found[2] == False:
            var start_index = x_idx - 3
            if digits_found[1]:
                start_index = x_idx - 2
            return get_number(start_index, x_idx, y_range)
        elif digits_found[2] == True and digits_found[0] == False:
            var start_index = x_idx + 3
            if digits_found[1]:
                start_index = x_idx + 2
            return get_number(x_idx, start_index, y_range)
        elif digits_found[0] == False and digits_found[1] == True and digits_found[2] == False :
            return atol(y_range[x_idx])
        else:
            return atol(y_range[x_idx-1] + y_range[x_idx] + y_range[x_idx+1])
            
    return 1

fn count_above_below_numbers(digits_found: StaticTuple[3, Bool]) -> Int:
    """
    Combinations
    No numbers
    - 0 0 0: No numbers above.

    Single number
    - 0 0 1: Number above right (has to be a single number)
    - 0 1 0: Number above (has to be a single number)
    - 0 1 1: Number above and number above right (has to be a single number)
    - 1 0 0: Number above left (has to be a single number)
    - 1 1 0: Number above left and number above (has to be a single number)
    - 1 1 1: Number above left, number above, and number above right (has to be a single number)

    Two numbers
    - 1 0 1: Number above left and number above right (has to be a two separate numbers).
    """
    if digits_found[0] == False and digits_found[1] == False and digits_found[2] == False:
        return 0
    elif digits_found[0] == True and digits_found[1] == False and digits_found[2] == True:
        return 2
    else:
        return 1

fn check_above(x_idx: Int, y_idx: Int, y_range: DynamicVector[String]) -> StaticTuple[3, Bool]:
    """
    Checks above the x & y coordinates given to see if there is are digit in any slot.

    Returns a tuple of 3 booleans:
    - above_left_is_number: 0
    - above_is_number: 1
    - above_right_is_number: 2.
    """
    var above_left_is_number: Bool = False
    var above_is_number: Bool = False
    var above_right_is_number: Bool = False
    if y_idx - 1 >= 0:
        let line = y_range[y_idx - 1]
        if x_idx - 1 >= 0:
            above_left_is_number = is_digit(line[x_idx - 1])
        if x_idx + 1 < len(line):
            above_right_is_number = is_digit(line[x_idx + 1])
        above_is_number = is_digit(line[x_idx])
    return StaticTuple[3, Bool](above_left_is_number, above_is_number, above_right_is_number)

fn check_below(x_idx: Int, y_idx: Int, y_range: DynamicVector[String]) -> StaticTuple[3, Bool]:
    """
    Checks below the x & y coordinates given to see if there is are digit in any slot.

    Returns a tuple of 3 booleans:
    - below_left_is_number: 0
    - below_is_number: 1
    - below_right_is_number: 2.
    """
    var below_left_is_number: Bool = False
    var below_is_number: Bool = False
    var below_right_is_number: Bool = False

    if y_idx + 1 < len(y_range):
        let line = y_range[y_idx + 1]
        if x_idx - 1 >= 0:
            below_left_is_number = is_digit(line[x_idx - 1])
        if x_idx + 1 < len(line):
            below_right_is_number = is_digit(line[x_idx + 1])
        below_is_number = is_digit(line[x_idx])
    return StaticTuple[3, Bool](below_left_is_number, below_is_number, below_right_is_number)

fn check_left(x_idx: Int, y_idx: Int, y_range: String[]) -> Bool:
    """
    Checks left of the x & y coordinates given to see if there is are digit in any slot.
    """
    if x_idx - 1 >= 0:
        return is_digit(y_range[x_idx - 1])
    return False

fn check_right(x_idx: Int, y_idx: Int, y_range: String[]) -> Bool:
    """
    Checks right of the x & y coordinates given to see if there is are digit in any slot.
    """
    if x_idx + 1 < len(y_range):
        return is_digit(y_range[x_idx + 1])
    return False


# Part 2 - Logic
fn main() raises:
    let input: String
    let filename = "inputs/day3/input.txt"
    with open(filename, "r") as f:
        input = f.read()

    var num_total: Int = 0
    let y_range = input.split("\n")
    for y_idx in range(len(y_range)):
        let x_range = y_range[y_idx]
        for x_idx in range(len(x_range)):
            if is_asterisk(x_range[x_idx]) == False:
                continue
            print_no_newline("Found an asterisk at: x:" + str(x_idx) + ", y:" + str(y_idx))
            # Check for numbers
            let digits_above = check_above(x_idx, y_idx, y_range)
            let digits_below = check_below(x_idx, y_idx, y_range)
            let digit_left = check_left(x_idx, y_idx, y_range[y_idx])
            let digit_right = check_right(x_idx, y_idx, y_range[y_idx])

            var nearby_numbers = 0
            nearby_numbers += count_above_below_numbers(digits_above)
            nearby_numbers += count_above_below_numbers(digits_below)
            if digit_left:
                nearby_numbers += 1
            if digit_right:
                nearby_numbers += 1
            print_no_newline(" - Nearby numbers: " + str(nearby_numbers))
            
            # Must be exactly 2
            # print("Nearby numbers: " + str(nearby_numbers))
            if nearby_numbers != 2:
                print("\n")
                continue

            let numbers_above = count_above_below_numbers(digits_above)
            var ratio_value = 1
            if numbers_above > 0:
                let number = get_above_below_numbers(x_idx, digits_above, y_range[y_idx - 1], numbers_above)
                print_no_newline(" - Numbers above: " + str(number))
                ratio_value *= number
            let numbers_below = count_above_below_numbers(digits_below)
            if numbers_below > 0:
                let number = get_above_below_numbers(x_idx, digits_below, y_range[y_idx + 1], numbers_below)
                print_no_newline(" - Numbers below: " + str(number))
                ratio_value *= number
            if digit_left:
                let number = get_number(x_idx - 3, x_idx, y_range[y_idx])
                print_no_newline(" - Number Left: " + str(number))
                ratio_value *= number
            if digit_right:
                let number = get_number(x_idx, x_idx + 3, y_range[y_idx])
                print_no_newline(" - Number Right: " + str(number))
                ratio_value *= number
            print(" - Ratio value: " + str(ratio_value) + " - Current total: " + str(num_total))
            num_total += ratio_value
    # Check tests
    if filename == "inputs/day3/test_input.txt":
        testing.assert_equal(num_total, 467835)
    elif filename == "inputs/day3/testb_input.txt":
        testing.assert_equal(num_total, 2235)
    elif filename == "inputs/day3/testc_input.txt":
        testing.assert_equal(num_total, 192060 + 38845 + 281064 + 31784 + 113870)
    elif filename == "inputs/day3/testd_input.txt":
        testing.assert_equal(num_total, 263758)
    elif filename == "inputs/day3/teste_input.txt":
        testing.assert_equal(num_total, 0)
    elif filename == "inputs/day3/testf_input.txt":
        testing.assert_equal(num_total, 306 + 1464)
    elif filename == "inputs/day3/testg_input.txt":
        testing.assert_equal(num_total, 6756)
    elif filename == "inputs/day3/testh_input.txt":
        testing.assert_equal(num_total, 182 + 65 + 195)
    elif filename == "inputs/day3/testi_input.txt":
        testing.assert_equal(num_total, 1170)
    elif filename == "inputs/day3/testj_input.txt": # This fucking case can die in a hole!!!
        testing.assert_equal(num_total, 1432)

    print("The total number is: " + str(num_total))



            
            


# Part 1 - Logic
# fn main() raises:
#     let input: String
#     let filename = "inputs/day3/input.txt"
#     with open(filename, "r") as f:
#         input = f.read()

#     var num_total: Int = 0
#     let y_range = input.split("\n")
#     for y_idx in range(len(y_range)):
#         let x_range = y_range[y_idx]
#         var current_num_str: String = ""
#         var current_num_has_symbol: Bool = False
#         for x_idx in range(len(x_range)):
#             # Check if the current character is a digit
#             let char = x_range[x_idx]
#             if is_digit(char) == False:
#                 continue
#             current_num_str += char

#             # Check if there is a symbol around the character
#             # Check above
#             if y_idx - 1 >= 0:
#                 let above_line = y_range[y_idx - 1]
#                 if x_idx - 1 >= 0:
#                     let is_above_left_a_symbol = is_symbol(above_line[x_idx - 1])
#                     if is_above_left_a_symbol:
#                         current_num_has_symbol = True
#                 if x_idx + 1 < len(above_line):
#                     let is_above_right_a_symbol = is_symbol(above_line[x_idx + 1])
#                     if is_above_right_a_symbol:
#                         current_num_has_symbol = True
#                 let is_above_a_symbol = is_symbol(above_line[x_idx])
#                 if is_above_a_symbol:
#                     current_num_has_symbol = True

#             # Check below
#             if y_idx + 1 < len(y_range):
#                 let below_line = y_range[y_idx + 1]
#                 if x_idx - 1 >= 0:
#                     let is_below_left_a_symbol = is_symbol(below_line[x_idx - 1])
#                     if is_below_left_a_symbol:
#                         current_num_has_symbol = True
#                 if x_idx + 1 < len(below_line):
#                     let is_below_right_a_symbol = is_symbol(below_line[x_idx + 1])
#                     if is_below_right_a_symbol:
#                         current_num_has_symbol = True
#                 let is_below_a_symbol = is_symbol(below_line[x_idx])
#                 if is_below_a_symbol:
#                     current_num_has_symbol = True

#             # Check left
#             if x_idx - 1 >= 0:
#                 let is_left_a_symbol = is_symbol(x_range[x_idx - 1])
#                 if is_left_a_symbol:
#                     current_num_has_symbol = True

#             # Check right
#             if x_idx + 1 < len(x_range):
#                 let is_right_a_symbol = is_symbol(x_range[x_idx + 1])
#                 if is_right_a_symbol:
#                     current_num_has_symbol = True

#             # Check if the next character is a digit
#             var is_next_char_digit = False
#             if x_idx + 1 < len(x_range):
#                 let next_char = x_range[x_idx + 1]
#                 is_next_char_digit = is_digit(next_char)
#             if is_next_char_digit == False or x_idx + 1 == len(x_range):
#                 # Reached end of number. If it has a symbol, add it to the total.
#                 # Then we reset the current number and symbol flag
#                 if current_num_has_symbol:
#                     num_total += atol(current_num_str)
#                 current_num_str = ""
#                 current_num_has_symbol = False

#     # Check tests
#     if filename == "inputs/day3/test_input.txt":
#         testing.assert_equal(num_total, 4361)
#     elif filename == "inputs/day3/testb_input.txt":
#         testing.assert_equal(num_total, 2890)
#     elif filename == "inputs/day3/testc_input.txt":
#         testing.assert_equal(num_total, 6423)
#     elif filename == "inputs/day3/testd_input.txt":
#         testing.assert_equal(num_total, 5552)
#     elif filename == "inputs/day3/teste_input.txt":
#         testing.assert_equal(num_total, 202)

#     print("The total number is: " + str(num_total))


#
