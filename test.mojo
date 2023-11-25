fn split_string(input: StringRef, sep: String) -> DynamicVector[StringRef]:
    let sep_len = len(sep)
    let input_len = len(input)
    var output: DynamicVector[StringRef] = DynamicVector[StringRef]()
    var start = 0
    var end = 0
    while end < input_len:
        let current_char = String(input)[end:end+1]
        if current_char == sep:
            var sub_str = String(input)[start:end+sep_len]
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

fn split_string_simd(input: StringRef, sep: String):
    pass
    

fn main():
    let x = "Hello World! This is a test."

    # My basic first implementation
    let strings = split_string(StringRef(x), " ")
    for i in range(len(strings)):
        print(strings[i])
    
    