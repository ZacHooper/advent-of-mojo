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