from day1 import max_index
import testing

fn main():
    # Test max_index
    # Create mock vetor
    let items = [6000, 4000, 27000, 10000]
    var mock_calories: DynamicVector[Int] = DynamicVector[Int]()
    for i in range(len(items)):
        mock_calories.push_back(i)
    
    # Test function
    let result = max_index(mock_calories)

    let max_index_test_res = testing.assert_equal(result, 3)

