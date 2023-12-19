from algorithm.sort import sort
from helpers.text import is_digit
from utils.vector import InlinedFixedVector


fn hand_map(char: String, is_part_two: Bool = False) raises -> Int:
    if is_digit(char):
        return atol(char)
    elif char == "A":
        return 14
    elif char == "K":
        return 13
    elif char == "Q":
        return 12
    elif char == "J":
        if is_part_two:
            return 1
        else:
            return 11
    elif char == "T":
        return 10
    else:
        print("You done fucked up AAron")
        return 0


fn is_one_pair(hand: SIMD[DType.uint8, 8]) -> Bool:
    """
    Will have 4 matches.
    """
    let num_matches = hand.reduce_add()
    if num_matches == 4:
        return True
    else:
        return False


fn is_two_pair(hand: SIMD[DType.uint8, 8]) -> Bool:
    """
    Must be 01010 or 00101.
    """
    let condition_1 = SIMD[DType.uint8, 8](0, 1, 0, 1, 0, 1, 1, 1)
    let condition_2 = SIMD[DType.uint8, 8](0, 0, 1, 0, 1, 1, 1, 1)
    let condition_3 = SIMD[DType.uint8, 8](0, 1, 0, 0, 1, 1, 1, 1)
    if hand == condition_1 or hand == condition_2 or hand == condition_3:
        return True
    else:
        return False


fn is_three_of_kind(hand: SIMD[DType.uint8, 8]) -> Bool:
    """
    Must be 01100 or 00110 or 00011.
    """
    let condition_1 = SIMD[DType.uint8, 8](0, 1, 1, 0, 0, 1, 1, 1)
    let condition_2 = SIMD[DType.uint8, 8](0, 0, 1, 1, 0, 1, 1, 1)
    let condition_3 = SIMD[DType.uint8, 8](0, 0, 0, 1, 1, 1, 1, 1)
    if hand == condition_1 or hand == condition_2 or hand == condition_3:
        return True
    else:
        return False


fn is_full_house(hand: SIMD[DType.uint8, 8]) -> Bool:
    """
    Must be 01101 or 01011.
    """
    let condition_1 = SIMD[DType.uint8, 8](0, 1, 1, 0, 1, 1, 1, 1)
    let condition_2 = SIMD[DType.uint8, 8](0, 1, 0, 1, 1, 1, 1, 1)
    if hand == condition_1 or hand == condition_2:
        return True
    else:
        return False


fn is_four_of_kind(hand: SIMD[DType.uint8, 8]) -> Bool:
    """
    Must be 01110 or 00111.
    """
    let condition_1 = SIMD[DType.uint8, 8](0, 1, 1, 1, 0, 1, 1, 1)
    let condition_2 = SIMD[DType.uint8, 8](0, 0, 1, 1, 1, 1, 1, 1)
    if hand == condition_1 or hand == condition_2:
        return True
    else:
        return False


fn is_five_of_kind(hand: SIMD[DType.uint8, 8]) -> Bool:
    """
    Will have 8 matches.
    """
    let num_matches = hand.reduce_add()
    if num_matches == 8:
        return True
    else:
        return False


fn get_hand_type(cards: DynamicVector[Int]) -> Int:
    """
    We sort the hand. Then copy the hand and shift one to the right.
    We then compare the indexes of the hand and shifted hand.
    Every hand type will always return a unique set of true/false values
    that we can then use to determine the hand.

    EG. Given this hand: 6, 14, 10, 12, 6 (6ATQ6). Which is a One Pair.
     6, 6, 10, 12, 14
    14, 6,  6, 10, 12
     F, T,  F,  F,  F

    Because there is only ONE true after the comparison we know it MUST be a one pair hand.

    EG. Given this hand: 6, 7, 7, 7, 6 (67776). Which is a full house
        6, 6, 7, 7, 7
        7, 6, 6, 7, 7
        F, T, F, T, T

    Because there are THREE true values we know it's either a full house or a four of a kind.
    We can then compare the true and false options for both hands to determine which it exactly is.

    (match count. Plus three due to SIMD buffer)
    Nothing = 0 (0),
    One Pair = 1 (1),
    Two Pair = 2 (2),
    three of a kind = 3 (2),
    Full house = 4 (3),
    four of a kind = 5 (3),
    five of a kind = 6 (5).
    """
    var s_cards = cards
    sort(s_cards)
    let simd_cards = SIMD[DType.uint8, 8](
        s_cards[0], s_cards[1], s_cards[2], s_cards[3], s_cards[4], 0, 0, 0
    )
    let right_shifted_cards = SIMD[DType.uint8, 8](
        s_cards[4], s_cards[0], s_cards[1], s_cards[2], s_cards[3], 0, 0, 0
    )
    # Count the matches (note that the last 3 elements are always 0 so we account for that)
    let matches = (simd_cards == right_shifted_cards).cast[DType.uint8]()
    let match_count = matches.reduce_add()

    # Count Jokers
    let joker_simd = SIMD[DType.uint8, 8](1)
    let joker_count = (simd_cards == joker_simd).cast[DType.uint8]().reduce_add()

    if is_five_of_kind(matches) 
        or (is_four_of_kind(matches) and joker_count == 1)
        or (is_full_house(matches) and joker_count == 2)
        or (is_full_house(matches) and joker_count == 3)
        or (is_four_of_kind(matches) and joker_count == 4):
        return 6
    elif (is_four_of_kind(matches) and joker_count == 0) 
        or (is_three_of_kind(matches) and joker_count == 1)
        or (is_two_pair(matches) and joker_count == 2)
        or (is_three_of_kind(matches) and joker_count == 3):
        return 5
    elif (is_full_house(matches) and joker_count == 0)
        or (is_two_pair(matches) and joker_count == 1):
        return 4
    elif (is_three_of_kind(matches) and joker_count == 0)
        or (is_one_pair(matches) and joker_count == 1)
        or (is_one_pair(matches) and joker_count == 2):
        return 3
    elif is_two_pair(matches):
        return 2
    elif is_one_pair(matches):
        return 1
    elif joker_count == 1:
        return 1
    else:
        return 0


@value
struct Hand(Stringable, CollectionElement):
    var bid: Int
    var cards: DynamicVector[Int]
    var hand_type: Int

    fn __init__(inout self, raw_line: String, is_part_two: Bool = False) raises:
        let inputs = raw_line.split(" ")
        self.bid = atol(inputs[1])

        var cards = DynamicVector[Int]()
        for i in range(len(inputs[0])):
            let card = inputs[0][i]
            cards.push_back(hand_map(card, is_part_two))
        self.cards = cards
        self.hand_type = get_hand_type(cards)

    fn __str__(self) -> String:
        var output: String = "Bid: " + str(self.bid) + " Cards: "
        for i in range(len(self.cards)):
            let card = self.cards[i]
            if i == len(self.cards) - 1:
                output += str(card)
            else:
                output += str(card) + ", "
        output += " Hand Type: " + str(self.hand_type)
        return output

    fn __eq__(self, other: Hand) -> Bool:
        let same_hand = self.hand_type == other.hand_type
        let same_card_order = (self.cards[0] == other.cards[0]) and (
            self.cards[1] == other.cards[1]
        ) and (self.cards[2] == other.cards[2]) and (
            self.cards[3] == other.cards[3]
        ) and (
            self.cards[4] == other.cards[4]
        )
        return same_hand and same_card_order

    fn __lt__(self, other: Hand) -> Bool:
        if self.hand_type < other.hand_type:
            return True
        if self.hand_type > other.hand_type:
            return False
        # If the hand types are the same we need to compare the cards
        for i in range(5):
            if self.cards[i] < other.cards[i]:
                return True
            if self.cards[i] > other.cards[i]:
                return False
        return False

    fn __gt__(self, other: Hand) -> Bool:
        if self.hand_type > other.hand_type:
            return True
        if self.hand_type < other.hand_type:
            return False
        for i in range(5):
            if self.cards[i] == other.cards[i]:
                continue
            if self.cards[i] > other.cards[i]:
                return True
        return False


fn sort_hands(inout hands: DynamicVector[Hand]) -> DynamicVector[Hand]:
    """Use the selection sorting method."""
    let size = len(hands)
    for ind in range(size):
        var min_index = ind

        for j in range(ind + 1, size):
            # select the minimum element in every iteration
            if hands[j] < hands[min_index]:
                min_index = j
        # swapping the elements to sort the array
        let temp = hands[ind]
        hands[ind] = hands[min_index]
        hands[min_index] = temp
    return hands


fn main() raises:
    # 2, 3, 4, 5, 6, 7, 8, 9, T=10, J=11, Q=12, K=13, A=14

    let input: String
    let filename = "inputs/day7/input.txt"
    with open(filename, "r") as f:
        input = f.read()

    let lines = input.split("\n")
    var hands = DynamicVector[Hand]()
    for i in range(len(lines)):
        let line = lines[i]
        hands.push_back(Hand(line, True))

    for i in range(len(hands)):
        let hand = hands[i]
        print(str(hand))

    let sorted_hands = sort_hands(hands)
    print("Sorted Hands:")

    for i in range(len(sorted_hands)):
        let hand = sorted_hands[i]
        print(str(hand))

    var total_winnings = 0
    for i in range(len(sorted_hands)):
        let hand = sorted_hands[i]
        total_winnings += hand.bid * (i + 1)

    print("Total Winnings: " + str(total_winnings))

    let test_hand = Hand("47883 869")
    let test_hand_2 = Hand("749K3 869")
    print(test_hand < test_hand_2)
