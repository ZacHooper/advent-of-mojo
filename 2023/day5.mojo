from utils.vector import InlinedFixedVector


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


# Part 1 Seeds
# @value
# struct Seeds(Stringable):
#     var seeds: InlinedFixedVector[Int, 4]

#     fn __init__(inout self, text: String) raises:
#         # Parse the seed values
#         let just_numbers = text.replace("seeds: ", "")
#         let split_numbers = just_numbers.split(" ")
#         self.seeds = InlinedFixedVector[Int, 4](len(split_numbers))
#         for i in range(len(split_numbers)):
#             let number = atol(split_numbers[i])
#             self.seeds.append(number)

#     fn __str__(self) -> String:
#         var output: String = "Seeds: "
#         for i in range(len(self.seeds)):
#             output += str(self.seeds[i])
#             if i < len(self.seeds) - 1:
#                 output += ", "
#         return output


# Part 2 Seeds
@value
struct Seeds(Stringable):
    var seeds: DynamicVector[SeedRange]

    fn __init__(inout self, text: String) raises:
        # Parse the seed values
        let just_numbers = text.replace("seeds: ", "")
        let split_numbers = just_numbers.split(" ")
        self.seeds = DynamicVector[SeedRange]()
        for i in range(0, len(split_numbers), 2):
            let min = atol(split_numbers[i])
            let range = atol(split_numbers[i + 1])
            self.seeds.push_back(SeedRange(min, min + range, 0))

    fn __str__(self) -> String:
        var output: String = "Seeds: "
        for i in range(len(self.seeds)):
            output += str(self.seeds[i])
            if i < len(self.seeds) - 1:
                output += ", "
        return output


@value
struct SeedRange(Stringable, CollectionElement):
    var min: Int
    var max: Int
    var range: Int
    var map_step: Int

    fn __init__(inout self, min: Int, max: Int, map_step: Int):
        self.min = min
        self.max = max
        self.range = max - min
        self.map_step = map_step

    fn __init__(inout self, existing_range: SeedRange, map_step: Int):
        """
        Create a new seed range from an existing one but with an updated map step.
        """
        self.min = existing_range.min
        self.max = existing_range.max
        self.range = existing_range.range
        self.map_step = map_step

    fn __str__(self) -> String:
        return str(self.min) + " -> " + str(self.max) + " (" + str(self.map_step) + ")"


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

    fn get_destination(self, value: Int) -> Int:
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

    fn get_destination(self, value: Int) -> Int:
        """
        Given an exact seed value, convert it.
        """
        for i in range(len(self.ranges)):
            if self.ranges[i].contains(value):
                return self.ranges[i].get_destination(value)
        return value

    fn get_destination(self, seed_range: SeedRange) -> DynamicVector[SeedRange]:
        """
        Given a seed range check if it's inside any of the source ranges.
        If it's not then split the seed range.
        """
        var result = DynamicVector[SeedRange]()
        for i in range(len(self.ranges)):
            # If entire seed in range return new seed with min & max values converted
            if self.ranges[i].contains(seed_range.min) and self.ranges[i].contains(
                seed_range.max
            ):
                let new_min = self.ranges[i].get_destination(seed_range.min)
                let new_max = self.ranges[i].get_destination(seed_range.max)
                result.push_back(SeedRange(new_min, new_max, seed_range.map_step + 1))
                return result

            # If Minimum in range but max isn't split the range.
            if self.ranges[i].contains(seed_range.min):
                # seed range inside range
                let inside_min = self.ranges[i].get_destination(seed_range.min)
                let inside_max = self.ranges[i].get_destination(
                    self.ranges[i].source_max
                )
                let inside_seed_range = SeedRange(
                    inside_min, inside_max, seed_range.map_step + 1
                )
                result.push_back(inside_seed_range)

                # seed outside range
                let outside_min = self.ranges[i].source_max + 1
                let outside_max = seed_range.max
                # Keep map step the same so that this seed range attempts to run through this map again with
                # update values
                let outside_seed_range = SeedRange(
                    outside_min, outside_max, seed_range.map_step
                )
                result.push_back(outside_seed_range)
                return result

            # If Maximum in range but min isn't split the range.
            if self.ranges[i].contains(seed_range.max):
                # seed range inside range
                let inside_min = self.ranges[i].get_destination(
                    self.ranges[i].source_min
                )
                let inside_max = self.ranges[i].get_destination(seed_range.max)
                let inside_seed_range = SeedRange(
                    inside_min, inside_max, seed_range.map_step + 1
                )
                result.push_back(inside_seed_range)

                # seed outside range
                let outside_min = seed_range.min
                let outside_max = self.ranges[i].source_min - 1
                # Keep map step the same so that this seed range attempts to run through this map again with
                # update values
                let outside_seed_range = SeedRange(
                    outside_min, outside_max, seed_range.map_step
                )
                result.push_back(outside_seed_range)
                return result

        # If no match found return original seed range
        let new_seed_range = SeedRange(seed_range, seed_range.map_step + 1)
        result.push_back(new_seed_range)
        return result


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
    let soil = seed_to_soil_map.get_destination(seed)
    let fertilizer = seed_to_fertilizer_map.get_destination(soil)
    let water = fertilizer_to_water_map.get_destination(fertilizer)
    let light = water_to_light_map.get_destination(water)
    let temperature = light_to_temperature_map.get_destination(light)
    let humidity = temperature_to_humidity_map.get_destination(temperature)
    let location = humidity_to_location_map.get_destination(humidity)
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


@value
struct QueueItem(CollectionElement):
    var range: SeedRange
    var starting_map: Int


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

    var queue = seeds.seeds

    while len(queue) > 0:
        # Get first item in queue
        let seed_range = queue.pop_back()
        print(seed_range)

        # Process through right map
        var processed_seed_ranges = DynamicVector[SeedRange]()
        if seed_range.map_step == 0:
            processed_seed_ranges = seed_to_soil_map.get_destination(seed_range)
        elif seed_range.map_step == 1:
            processed_seed_ranges = seed_to_fertilizer_map.get_destination(seed_range)
        elif seed_range.map_step == 2:
            processed_seed_ranges = fertilizer_to_water_map.get_destination(seed_range)
        elif seed_range.map_step == 3:
            processed_seed_ranges = water_to_light_map.get_destination(seed_range)
        elif seed_range.map_step == 4:
            processed_seed_ranges = light_to_temperature_map.get_destination(seed_range)
        elif seed_range.map_step == 5:
            processed_seed_ranges = temperature_to_humidity_map.get_destination(
                seed_range
            )
        elif seed_range.map_step == 6:
            processed_seed_ranges = humidity_to_location_map.get_destination(seed_range)
        else:
            # Get the lowest number minimum range value from the ranges returned
            if seed_range.min < lowest_location_number or lowest_location_number == 0:
                print(
                    "Changing lowest number: "
                    + str(lowest_location_number)
                    + " -> "
                    + str(seed_range.min)
                )
                lowest_location_number = seed_range.min
            continue

        for i in range(len(processed_seed_ranges)):
            queue.push_back(processed_seed_ranges[i])
        print("Queue Length: " + str(len(queue)))

    # Part 1
    # while len(seeds.seeds) > 0:
    #     pass

    # for i in range(len(seeds.seeds)):
    #     let seed = seeds.seeds[i]
    #     let location = get_location_of_seed(
    #         seed,
    #         seed_to_soil_map,
    #         seed_to_fertilizer_map,
    #         fertilizer_to_water_map,
    #         water_to_light_map,
    #         light_to_temperature_map,
    #         temperature_to_humidity_map,
    #         humidity_to_location_map,
    #     )
    #     if lowest_location_number == 0 or location < lowest_location_number:
    #         lowest_location_number = location

    print(lowest_location_number)
