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


@value
struct StringDynamicVector[T: CollectionElement](Stringable):
    var data: DynamicVector[String]

    fn __init__(inout self):
        self.data = DynamicVector[String]()

    fn __init__(inout self, data: DynamicVector[String]):
        self.data = data

    fn push_back(inout self, value: String):
        self.data.push_back(value)

    fn __getitem__(self, index: Int) -> T:
        return self.data[index]

    fn __setitem__(inout self, index: Int, value: String):
        self.data[index] = value

    fn __len__(self) -> Int:
        return self.data.__len__()

    fn __str__(self) -> String:
        var output: String = "["
        for i in range(len(self.data)):
            output += str(self.data[i])
            if i < len(self.data) - 1:
                output += ", "
        output += "]"
        return output
