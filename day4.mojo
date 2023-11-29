from helpers import text


struct Elf:
    var min: Int
    var max: Int

    fn __init__(inout self, range: String) raises:
        let dash = String(range).find("-")
        let min = String(range)[0:dash]
        let max = String(range)[dash + 1:]
        self.min = atol(min)
        self.max = atol(max)

    fn __str__(self) -> String:
        return "Elf(" + String(self.min) + " - " + String(self.max) + ")"
    
    fn range_is_inside(self, other_elf: Elf) -> Bool:
        return self.min >= other_elf.min and self.max <= other_elf.max
    
    fn overlaps(self, other_elf: Elf) -> Bool:
        return self.min <= other_elf.max and self.max >= other_elf.min

fn main() raises:
    let input: String
    with open("inputs/day4_input.txt", "r") as f:
        input = f.read()

    let pairs = text.split_string(input, "\n")

    var count_of_full_contained_elves = 0
    var count_of_overlapping_elves = 0
    for i in range(len(pairs)):
        let comma_idx = String(pairs[i].data).find(",")
        let elf_1 = Elf(String(pairs[i])[0:comma_idx])
        let elf_2 = Elf(String(pairs[i])[comma_idx + 1:])
        let has_fully_contained_elf = elf_1.range_is_inside(elf_2) or elf_2.range_is_inside(elf_1)
        let has_overlapping_elf = elf_1.overlaps(elf_2) or elf_2.overlaps(elf_1)
        if has_fully_contained_elf:
            count_of_full_contained_elves += 1
        if has_overlapping_elf:
            count_of_overlapping_elves += 1
        
    
    print("Count of fully contained elves: " + String(count_of_full_contained_elves))
    print("Count of overlapping elves: " + String(count_of_overlapping_elves))
        

        