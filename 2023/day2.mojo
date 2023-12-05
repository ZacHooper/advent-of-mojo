from helpers import text

fn get_game_number(game_contents: String) raises -> Int:
    let game_number = game_contents.replace("Game ", "").replace(":", "")
    return atol(game_number)

fn get_colour(selection: String) raises -> String:
    if selection.find("blue") != -1:
        return "blue"
    elif selection.find("red") != -1:
        return "red"
    elif selection.find("green") != -1:
        return "green"
    else:
        raise Error("Invalid colour")

fn get_selections(game: String) raises -> StaticIntTuple[3]:
    """
    (blue, red, green).
    """
    let selections = game.split(",")
    var blue_count = 0
    var red_count = 0
    var green_count = 0
    for idx in range(len(selections)):
        let selection = selections[idx]
        let colour = get_colour(selection)
        let number = atol(text.strip_string(selection.replace(colour, "")))
        if colour == "blue":
            blue_count += number
        elif colour == "red":
            red_count += number
        elif colour == "green":
            green_count += number
        else:
            raise Error("Invalid colour")

    return StaticIntTuple[3](blue_count, red_count, green_count)

fn main() raises:
    let input: String
    with open("inputs/day2/input.txt", "r") as f:
        input = f.read()

    let blue_threshold = 14
    let red_threshold = 12
    let green_threshold = 13

    var id_count = 0
    var power: Int = 0
    
    let lines = input.split("\n")
    for idx in range(len(lines)):
        let line = lines[idx]

        var blue_max = 0
        var red_max = 0
        var green_max = 0

        let game_contents = line.split(":")
        let game_number = get_game_number(game_contents[0])

        let games = game_contents[1].split(";")
        for game_idx in range(len(games)):
            let game = games[game_idx]
            # print(game)
            let colour_counts = get_selections(game)
            if colour_counts[0] > blue_max:
                blue_max = colour_counts[0]
            if colour_counts[1] > red_max:
                red_max = colour_counts[1]
            if colour_counts[2] > green_max:
                green_max = colour_counts[2]

        # print("Blue: " + str(blue_total) + ", Red: " + red_total + ", Green: " + green_total)
        if blue_max <= blue_threshold and red_max <= red_threshold and green_max <= green_threshold:
            print(game_number)
            id_count += game_number
        
        power += blue_max * red_max * green_max

        
    print(id_count)
    print(power)


        
        