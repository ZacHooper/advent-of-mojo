from helpers import text
from helpers import vectors
from utils.vector import InlinedFixedVector


fn get_num_matches[
    winning_width: Int,
    guess_width: Int,
](
    owned winning_numbers: InlinedFixedVector[Int, winning_width],
    owned guesses: InlinedFixedVector[Int, guess_width],
) -> Int:
    var matches = 0
    for guess in guesses:
        if vectors.contains(winning_numbers, guess):
            matches += 1
    return matches


struct TodoList[size: Int]:
    var tasks: InlinedFixedVector[StringLiteral, size]

    fn __init__(inout self, capacity: Int):
        self.tasks.__init__(capacity)

    fn addTask(inout self, desc: StringLiteral, isComplete: Bool = False):
        if isComplete:
            print("Task: ", desc, " Is Complete")
        else:
            self.tasks.append(desc)
            print("Added Task: ", desc)


fn main() raises:
    let input: String
    let filename = "inputs/day4/input.txt"
    with open(filename, "r") as f:
        input = f.read()

    var total_points: Int = 0

    let games = input.split("\n")

    var num_scratchcards = InlinedFixedVector[Int, 0](len(games))
    for i in range(len(games)):
        num_scratchcards.append(0)

    for idx in range(len(games)):
        let game = games[idx]
        var matches = 0
        let inputs = game[9:].split("|")
        let winning_numbers_raw = text.strip_string(inputs[0]).split(" ")
        var winning_numbers = InlinedFixedVector[Int, 5](len(winning_numbers_raw))

        let guesses_raw = text.strip_string(inputs[1]).split(" ")
        var guesses = InlinedFixedVector[Int, 8](len(guesses_raw))

        for j in range(len(winning_numbers_raw)):
            let num = text.strip_string(winning_numbers_raw[j])
            if num == "":
                continue
            winning_numbers.append(atol(num))
        for j in range(len(guesses_raw)):
            let num = text.strip_string(guesses_raw[j])
            if num == "":
                continue
            guesses.append(atol(num))

        for guess in guesses:
            for winning_number in winning_numbers:
                if guess == winning_number:
                    print("Matched: ", guess)
                    matches += 1

        print("Game: ", idx, " Matches: ", matches, " Points: ", 2 ** (matches - 1))
        total_points += 2 ** (matches - 1)

        # part 2 - stuff
        # Run the copies
        num_scratchcards[idx] += 1
        for k in range(num_scratchcards[idx]):
            for j in range(1, matches + 1):
                num_scratchcards[idx + j] += 1

    print("Total Points: ", total_points)
    var part_2_total: Int = 0
    for scratch_count in num_scratchcards:
        part_2_total += scratch_count
    print(part_2_total)

    # p1 - 26914
    # p2 - 13080971
