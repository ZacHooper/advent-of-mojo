
fn has_int[datetype: DType, length: Int](a: SIMD[datetype, length], b: SIMD[datetype, length]) -> Bool:
    return (a == b).reduce_or()


fn string_to_simd[datetype: DType, length: Int](s: String) -> SIMD[datetype, length]:
    var simd = SIMD[datetype, length]()
    for i in range(length):
        simd[i] = ord(s[i])
    return simd


fn find_string_1(input: String) -> String:
    for i in range(len(input)):
        let search_range = input[i+1:]
        if search_range.find(input[i]) == -1:
            return input[i]
    return ""

fn find_string_2(input: String) -> String:
    let simd = string_to_simd[DType.float16, 32](input)
    for i in range(len(input)):
        let search_range = input[i+1:]
        print(search_range)
        let simd_search_range = string_to_simd[DType.float16, 32](search_range)
        print(simd_search_range)
        let simd_i = string_to_simd[DType.float16, 32](input[i])
        print(simd_i)
        print(has_int(simd_search_range, simd_i))
        if has_int(simd_search_range, simd_i) == False:
            return input[i]
    return ""
        
fn do_speed_test(input: String) -> None:
    let start = time.now()
    let y = find_string_1(input)
    let end = time.now()
    print("Found " + y + " in " + String(end - start) + "ns")

    let start_2 = time.now()
    let z = find_string_2(input)
    let end_2 = time.now()
    print("Found " + z + " in " + String(end_2 - start_2) + "ns")
    
import time
fn main():
    let x = "vJrwpWtwJgWrhcsFMMfFFhFp"
    do_speed_test(x)

    # 385000ns
    # 39000ns 10x faster using SIMD

    # Now let's move the char so it's not at the beginning
    let y = "JrwpWtwJgWrvhcsFMMfFFhFp"
    do_speed_test(y)

    # 1000ns
    # 37000ns 37x slower? using SIMD