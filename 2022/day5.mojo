# 0 index is the bottom of the stack

from helpers import text

@value
struct Instruction:
    var amount: Int
    var stack_from: Int
    var stack_to: Int

    fn __init__(inout self, instruction: StringRef) raises:
        let instruction_split: DynamicVector[StringRef] = text.split_string(instruction, " ")
        self.amount = atol(instruction_split[1])
        self.stack_from = atol(instruction_split[3])
        self.stack_to = atol(instruction_split[5])
    
    fn __str__(self) -> String:
        return "Moving " + String(self.amount) + " from " + String(self.stack_from) + " to " + String(self.stack_to)


fn main() raises:
    # Test Stacks
    var test_stack1: DynamicVector[UInt8] = DynamicVector[UInt8]()
    var test_stack2: DynamicVector[UInt8] = DynamicVector[UInt8]()
    var test_stack3: DynamicVector[UInt8] = DynamicVector[UInt8]()
    # Stack 1
    test_stack1.push_back(ord("Z"))
    test_stack1.push_back(ord("N"))
    # Stack 2
    test_stack2.push_back(ord("M"))
    test_stack2.push_back(ord("C"))
    test_stack2.push_back(ord("D"))
    # Stack 3
    test_stack3.push_back(ord("P"))

    # Part 1 Stacks
    var stack1: DynamicVector[UInt8] = DynamicVector[UInt8]()
    var stack2: DynamicVector[UInt8] = DynamicVector[UInt8]()
    var stack3: DynamicVector[UInt8] = DynamicVector[UInt8]()
    var stack4: DynamicVector[UInt8] = DynamicVector[UInt8]()
    var stack5: DynamicVector[UInt8] = DynamicVector[UInt8]()
    var stack6: DynamicVector[UInt8] = DynamicVector[UInt8]()
    var stack7: DynamicVector[UInt8] = DynamicVector[UInt8]()
    var stack8: DynamicVector[UInt8] = DynamicVector[UInt8]()
    var stack9: DynamicVector[UInt8] = DynamicVector[UInt8]()

    # Stack 1
    stack1.push_back(ord("G"))
    stack1.push_back(ord("F"))
    stack1.push_back(ord("V"))
    stack1.push_back(ord("H"))
    stack1.push_back(ord("P"))
    stack1.push_back(ord("S"))
    # Stack 2
    stack2.push_back(ord("G"))
    stack2.push_back(ord("J"))
    stack2.push_back(ord("F"))
    stack2.push_back(ord("B"))
    stack2.push_back(ord("V"))
    stack2.push_back(ord("D"))
    stack2.push_back(ord("Z"))
    stack2.push_back(ord("M"))
    # Stack 3 GMLJN
    stack3.push_back(ord("G"))
    stack3.push_back(ord("M"))
    stack3.push_back(ord("L"))
    stack3.push_back(ord("J"))
    stack3.push_back(ord("N"))
    # Stack 4 NGZVDWP
    stack4.push_back(ord("N"))
    stack4.push_back(ord("G"))
    stack4.push_back(ord("Z"))
    stack4.push_back(ord("V"))
    stack4.push_back(ord("D"))
    stack4.push_back(ord("W"))
    stack4.push_back(ord("P"))
    # Stack 5 VRCB
    stack5.push_back(ord("V"))
    stack5.push_back(ord("R"))
    stack5.push_back(ord("C"))
    stack5.push_back(ord("B"))
    # Stack 6 VRSMPWLZ
    stack6.push_back(ord("V"))
    stack6.push_back(ord("R"))
    stack6.push_back(ord("S"))
    stack6.push_back(ord("M"))
    stack6.push_back(ord("P"))
    stack6.push_back(ord("W"))
    stack6.push_back(ord("L"))
    stack6.push_back(ord("Z"))
    # Stack 7 THP
    stack7.push_back(ord("T"))
    stack7.push_back(ord("H"))
    stack7.push_back(ord("P"))
    # Stack 8 QRSNCHZV
    stack8.push_back(ord("Q"))
    stack8.push_back(ord("R"))
    stack8.push_back(ord("S"))
    stack8.push_back(ord("N"))
    stack8.push_back(ord("C"))
    stack8.push_back(ord("H"))
    stack8.push_back(ord("Z"))
    stack8.push_back(ord("V"))
    # Stack 9 FLGPVQJ
    stack9.push_back(ord("F"))
    stack9.push_back(ord("L"))
    stack9.push_back(ord("G"))
    stack9.push_back(ord("P"))
    stack9.push_back(ord("V"))
    stack9.push_back(ord("Q"))
    stack9.push_back(ord("J"))

    let input: String
    with open("inputs/day5_input.txt", 'r') as f:
        input = f.read()

    let instructions: DynamicVector[StringRef] = text.split_string(input, "\n")

    var crane: DynamicVector[UInt8] = DynamicVector[UInt8]()
    for i in range(len(instructions)):
        let instruction: Instruction = Instruction(instructions[i])
        for j in range(instruction.amount):
            # Pick Up Block
            if instruction.stack_from == 1:
                crane.push_back(stack1.pop_back())
            elif instruction.stack_from == 2:
                crane.push_back(stack2.pop_back())
            elif instruction.stack_from == 3:
                crane.push_back(stack3.pop_back())
            elif instruction.stack_from == 4:
                crane.push_back(stack4.pop_back())
            elif instruction.stack_from == 5:
                crane.push_back(stack5.pop_back())
            elif instruction.stack_from == 6:
                crane.push_back(stack6.pop_back())
            elif instruction.stack_from == 7:
                crane.push_back(stack7.pop_back())
            elif instruction.stack_from == 8:
                crane.push_back(stack8.pop_back())
            elif instruction.stack_from == 9:
                crane.push_back(stack9.pop_back())
            else:
                raise Error("Invalid stack from")

        for j in range(instruction.amount): # Comment this out to pass part 1.
        # with the loop we pick up all the blocks at once and then place them all at once.
        # Without it we do it one by one
            # Place Block
            if instruction.stack_to == 1:
                stack1.push_back(crane.pop_back())
            elif instruction.stack_to == 2:
                stack2.push_back(crane.pop_back())
            elif instruction.stack_to == 3:
                stack3.push_back(crane.pop_back())
            elif instruction.stack_to == 4:
                stack4.push_back(crane.pop_back())
            elif instruction.stack_to == 5:
                stack5.push_back(crane.pop_back())
            elif instruction.stack_to == 6:
                stack6.push_back(crane.pop_back())
            elif instruction.stack_to == 7:
                stack7.push_back(crane.pop_back())
            elif instruction.stack_to == 8:
                stack8.push_back(crane.pop_back())
            elif instruction.stack_to == 9:
                stack9.push_back(crane.pop_back())
            else:
                raise Error("Invalid stack to")
    
    # Get the Top of each stack
    let stack1_top: String = chr(stack1.pop_back().to_int())
    let stack2_top: String = chr(stack2.pop_back().to_int())
    let stack3_top: String = chr(stack3.pop_back().to_int())
    let stack4_top: String = chr(stack4.pop_back().to_int())
    let stack5_top: String = chr(stack5.pop_back().to_int())
    let stack6_top: String = chr(stack6.pop_back().to_int())
    let stack7_top: String = chr(stack7.pop_back().to_int())
    let stack8_top: String = chr(stack8.pop_back().to_int())
    let stack9_top: String = chr(stack9.pop_back().to_int())


    print("Stack 1 Top: " + String(stack1_top))
    print("Stack 2 Top: " + String(stack2_top))
    print("Stack 3 Top: " + String(stack3_top))
    print("Stack 4 Top: " + String(stack4_top))
    print("Stack 5 Top: " + String(stack5_top))
    print("Stack 6 Top: " + String(stack6_top))
    print("Stack 7 Top: " + String(stack7_top))
    print("Stack 8 Top: " + String(stack8_top))
    print("Stack 9 Top: " + String(stack9_top))

    print(String().join(stack1_top, stack2_top, stack3_top, stack4_top, stack5_top, stack6_top, stack7_top, stack8_top, stack9_top))

    






    