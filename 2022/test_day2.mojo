from day2 import Game
from testing import assert_equal

fn test_calculate_result() -> None:
    # Test Draw
    let game: Game = Game("A", "X")
    let result: Int8 = game.calculate_result()
    let draw: Int8 = assert_equal(result, 1)

    # Test Win
    let game_2: Game = Game("A", "Y")
    let result_2: Int8 = game_2.calculate_result()
    let draw_2: Int8 = assert_equal(result_2, 2)

    # Test Loss
    let game_3: Game = Game("A", "Z")
    let result_3: Int8 = game_3.calculate_result()
    let draw_3: Int8 = assert_equal(result_3, 0)

fn test_calculate_your_score() -> None:
    # Test Draw w Rock (3 + 1)
    let game: Game = Game("A", "X")
    let result: Int8 = game.calculate_your_score()
    let draw: Int8 = assert_equal(result, 4)

    # Test Win w Paper (6 + 2)
    let game_2: Game = Game("A", "Y")
    let result_2: Int8 = game_2.calculate_your_score()
    let draw_2: Int8 = assert_equal(result_2, 8)

    # Test Loss w Scissors (0 + 3)
    let game_3: Game = Game("A", "Z")
    let result_3: Int8 = game_3.calculate_your_score()
    let draw_3: Int8 = assert_equal(result_3, 3)

fn test_calculate_choice_score() -> None:
    # Test Rock
    let game: Game = Game("A", "X")
    let result: Int8 = game.calculate_choice_score(game.my_choice)
    let draw: Int8 = assert_equal(result, 1)

    # Test Paper
    let game_2: Game = Game("A", "Y")
    let result_2: Int8 = game_2.calculate_choice_score(game.my_choice)
    let draw_2: Int8 = assert_equal(result_2, 2)

    # Test Scissors
    let game_3: Game = Game("A", "Z")
    let result_3: Int8 = game_3.calculate_choice_score(game.my_choice)
    let draw_3: Int8 = assert_equal(result_3, 3)

fn test_input_1() -> None:
    var data = DynamicVector[Game]()
    data.push_back(Game("A", "X"))
    data.push_back(Game("B", "Y"))
    data.push_back(Game("C", "Z"))

    var my_total_score = 0
    for i in range(len(data)):
        my_total_score += data[i].calculate_your_score()

    let res = assert_equal(my_total_score, 15)

fn test_input_2() -> None:
    var data = DynamicVector[Game]()
    data.push_back(Game("A", "X"))
    data.push_back(Game("B", "Y"))
    data.push_back(Game("C", "Z"))

    var my_total_score = 0
    for i in range(len(data)):
        my_total_score += data[i].calculate_your_score()

    let res = assert_equal(my_total_score, 12)

fn main() raises:
    test_calculate_result()
    test_calculate_choice_score()
    test_calculate_your_score()
    test_input_1()
    test_input_2()


    return

