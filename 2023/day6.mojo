from utils.vector import InlinedFixedVector


fn get_distance(race_duration: Int, time_button_pressed: Int) -> Int:
    return time_button_pressed * (race_duration - time_button_pressed)


@value
@register_passable
struct Race(CollectionElement, Stringable):
    var duration: Int
    var record: Int

    fn get_number_of_ways_to_beat_record(self) -> Int:
        var ways_to_beat_record: Int = 0
        for i in range(self.duration):
            let distance = get_distance(self.duration, i)
            if distance > self.record:
                ways_to_beat_record += 1
        return ways_to_beat_record

    fn __str__(self) -> String:
        return "Race: duration=" + str(self.duration) + " record=" + str(self.record)


fn main():
    ### PART 1 ###
    # var test_margin_of_error: Int = 1
    # let test_race_1 = Race(7, 9)
    # let test_race_2 = Race(15, 40)
    # let test_race_3 = Race(30, 200)
    # var test_races = InlinedFixedVector[Race, 3](3)
    # test_races.append(test_race_1)
    # test_races.append(test_race_2)
    # test_races.append(test_race_3)

    # for race in test_races:
    #     test_margin_of_error *= race.get_number_of_ways_to_beat_record()

    # print(test_margin_of_error)

    # var margin_of_error: Int = 1
    # let race_1 = Race(53, 250)
    # let race_2 = Race(91, 1330)
    # let race_3 = Race(67, 1081)
    # let race_4 = Race(68, 1025)
    # var races = InlinedFixedVector[Race, 4](4)
    # races.append(race_1)
    # races.append(race_2)
    # races.append(race_3)
    # races.append(race_4)

    # for race in races:
    #     print(race)
    #     let ways_to_win: Int = race.get_number_of_ways_to_beat_record()
    #     print(ways_to_win)
    #     margin_of_error *= ways_to_win

    # print(margin_of_error)

    ### PART 2 ###
    let test_race = Race(71530, 940200)
    print(test_race.get_number_of_ways_to_beat_record())
    let race = Race(53916768, 250133010811025)
    print(race.get_number_of_ways_to_beat_record())
