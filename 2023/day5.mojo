from utils.vector import InlinedFixedVector

# fn print_map(ranges: DynamicVector[Range]):
#     var output: String = "Seed to Soil Map:\n"
#         for i in range(len(self.ranges)):
#             output += str(self.ranges[i])
#             if i < len(self.ranges) - 1:
#                 output += "\n"
#         output += "\nOtherwise, the value is unchanged."
#         return output
#     for i in range(len(map)):
#         for j in range(len(map[i])):
#             print(map[i][j], terminator: "")
#         print("")


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


@value
struct Seeds(Stringable):
    var seeds: InlinedFixedVector[Int, 4]

    fn __init__(inout self, text: String) raises:
        # Parse the seed values
        let just_numbers = text.replace("seeds: ", "")
        let split_numbers = just_numbers.split(" ")
        self.seeds = InlinedFixedVector[Int, 4](len(split_numbers))
        for i in range(len(split_numbers)):
            let number = atol(split_numbers[i])
            self.seeds.append(number)

    fn __str__(self) -> String:
        var output: String = "Seeds: "
        for i in range(len(self.seeds)):
            output += str(self.seeds[i])
            if i < len(self.seeds) - 1:
                output += ", "
        return output


@value
@register_passable("trivial")
struct Range(Stringable, CollectionElement):
    var destination_min: Int
    var destination_max: Int
    var source_min: Int
    var source_max: Int
    var range_size: Int

    fn __init__(raw_range: String) raises -> Self:
        let split_range = raw_range.split(" ")
        let destination = atol(split_range[0])
        let source = atol(split_range[1])
        let range_size = atol(split_range[2])

        return Self {
            destination_min: destination,
            destination_max: destination + range_size - 1,
            source_min: source,
            source_max: source + range_size - 1,
            range_size: range_size,
        }

    fn contains(self, value: Int) -> Bool:
        return value >= self.source_min and value <= self.source_max

    fn get_source(self, value: Int) -> Int:
        """
        If the value is in the range then apply the transformation. Otherwise, return the value.
        """
        if self.contains(value):
            return self.destination_min + (value - self.source_min)
        else:
            return value

    fn __str__(self) -> String:
        return (
            "Range: "
            + str(self.source_min)
            + " - "
            + str(self.source_max)
            + " -> "
            + str(self.destination_min)
            + " - "
            + str(self.destination_max)
        )


@value
struct Map(Stringable):
    var ranges: InlinedFixedVector[Range, 4]

    fn __init__(inout self, ranges: InlinedFixedVector[Range, 4]):
        self.ranges = ranges

    fn __init__(inout self, raw_map: String) raises:
        let split_map = raw_map.split("\n")
        self.ranges = InlinedFixedVector[Range, 4](len(split_map) - 1)
        for i in range(1, len(split_map)):
            let range = Range(split_map[i])
            self.ranges.append(range)

    fn __str__(self) -> String:
        var output: String = ""
        for i in range(len(self.ranges)):
            output += str(self.ranges[i])
            if i < len(self.ranges) - 1:
                output += "\n"
        output += "\nOtherwise, the value is unchanged."
        return output

    fn get_source(self, value: Int) -> Int:
        for i in range(len(self.ranges)):
            if self.ranges[i].contains(value):
                return self.ranges[i].get_source(value)
        return value


fn get_location_of_seed(
    seed: Int,
    seed_to_soil_map: Map,
    seed_to_fertilizer_map: Map,
    fertilizer_to_water_map: Map,
    water_to_light_map: Map,
    light_to_temperature_map: Map,
    temperature_to_humidity_map: Map,
    humidity_to_location_map: Map,
    print_conversion: Bool = False,
) -> Int:
    """
    Converts the seed value through each of the maps to get the location value.
    """
    let soil = seed_to_soil_map.get_source(seed)
    let fertilizer = seed_to_fertilizer_map.get_source(soil)
    let water = fertilizer_to_water_map.get_source(fertilizer)
    let light = water_to_light_map.get_source(water)
    let temperature = light_to_temperature_map.get_source(light)
    let humidity = temperature_to_humidity_map.get_source(temperature)
    let location = humidity_to_location_map.get_source(humidity)
    if print_conversion:
        print(
            "Seed: ",
            seed,
            " -> ",
            soil,
            " -> ",
            fertilizer,
            " -> ",
            water,
            " -> ",
            light,
            " -> ",
            temperature,
            " -> ",
            humidity,
            " -> ",
            location,
        )
    return location


fn main() raises:
    # Open and Parse the File
    let input: String
    let filename = "inputs/day5/input.txt"
    with open(filename, "r") as f:
        input = f.read()

    let sections = StringDynamicVector[String](input.split("\n\n"))

    let seeds = Seeds(sections[0])

    let seed_to_soil_map = Map(sections[1])
    let seed_to_fertilizer_map = Map(sections[2])
    let fertilizer_to_water_map = Map(sections[3])
    let water_to_light_map = Map(sections[4])
    let light_to_temperature_map = Map(sections[5])
    let temperature_to_humidity_map = Map(sections[6])
    let humidity_to_location_map = Map(sections[7])

    var lowest_location_number: Int = 0
    for i in range(len(seeds.seeds)):
        let seed = seeds.seeds[i]
        let location = get_location_of_seed(
            seed,
            seed_to_soil_map,
            seed_to_fertilizer_map,
            fertilizer_to_water_map,
            water_to_light_map,
            light_to_temperature_map,
            temperature_to_humidity_map,
            humidity_to_location_map,
        )
        if lowest_location_number == 0 or location < lowest_location_number:
            lowest_location_number = location

    print(lowest_location_number)
