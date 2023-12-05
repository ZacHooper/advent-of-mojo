from helpers import text

@value
@register_passable
struct Game:
    """
    A struct to represent a scissors-paper-rock match.

    Parameters
    ----------
    opponent_choice : String
        The opponent's choice of scissors, paper, or rock.
    my_choice : String
        My choice of scissors, paper, or rock.

    Attributes
    ----------
    opponent_choice : String
        The opponent's choice of scissors, paper, or rock.
    my_choice : String
        My choice of scissors, paper, or rock.
    result : Int
        The result of the match. 0 = loss, 1 = draw, 2 = win.

    Methods
    -------
    calculate_result()
        Calculates the result of the match based on the opponent's choice and my choice.

    Opponents choices:
        - A: Rock
        - B: Paper
        - C: Scissors

    My Choices:
        - X: Rock
        - Y: Paper
        - Z: Scissors    

    Choice Scores:
        - Rock: 1
        - Paper: 2
        - Scissors: 3

    Result Scores:
        - Win: 6
        - Draw: 3
        - Loss: 0
    """
    var opponent_choice: StringRef
    var my_choice: StringRef

    fn calculate_result(borrowed self) -> Int:
        # # I win
        # if (
        #     self.opponent_choice == "A" and self.my_choice == "Y" 
        #     or self.opponent_choice == "B" and self.my_choice == "Z"
        #     or self.opponent_choice == "C" and self.my_choice == "X"
        # ):
        #     return 2
        # # I lose
        # if (
        #     self.opponent_choice == "A" and self.my_choice == "Z" 
        #     or self.opponent_choice == "B" and self.my_choice == "X"
        #     or self.opponent_choice == "C" and self.my_choice == "Y"
        # ):
        #     return 0
        # # Draw
        # else:
        #     return 1
        if self.my_choice == "X":
            return 0
        if self.my_choice == "Y":
            return 1
        if self.my_choice == "Z":
            return 2
        else:
            return -1

    fn calculate_my_choice(borrowed self) -> String:
        # Return Rock (X) 
        if (
            self.my_choice == "X" and self.opponent_choice == "B" # Lose
            or self.my_choice == "Y" and self.opponent_choice == "A" # Draw
            or self.my_choice == "Z" and self.opponent_choice == "C" # Win
        ):
            return "X"
        # Return Paper (Y)
        if (
            self.my_choice == "X" and self.opponent_choice == "C" # Lose
            or self.my_choice == "Y" and self.opponent_choice == "B" # Draw
            or self.my_choice == "Z" and self.opponent_choice == "A" # Win
        ):
            return "Y"
        # Return Scissors (Z)
        return "Z"

    
    fn calculate_choice_score(borrowed self, choice: String) -> Int:
        if choice == "X":
            return 1
        if choice == "Y":
            return 2
        if choice == "Z":
            return 3
        else:
            return 0

    fn calculate_your_score(borrowed self) -> Int:
        return self.calculate_result() * 3 + self.calculate_choice_score(self.calculate_my_choice())

            

fn main():
    let input: String
    try:
        with open("inputs/day2_input.txt", "r") as f:
            input = f.read()
    except IOError:
        print("Could not read file")
        return
    
    let matches = text.split_string(input, "\n")
    var my_total_score: Int = 0
    for i in range(len(matches)):
        let opponent_choice = matches[i][0]
        let my_choice = matches[i][2]
        let game = Game(opponent_choice, my_choice)
        my_total_score += game.calculate_your_score()
    
    print("My total score is: " + String(my_total_score))