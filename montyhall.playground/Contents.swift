import UIKit

var str = "Hello, playground"

extension Int {
    
    static func random(_ range : Int) -> Int {
        return Int(arc4random_uniform(UInt32(range)))
    }
    
    static func randomIndexes(count : Int, range : Int) -> [Int] {
        guard range > count else {
            print("Random indexes: range must be greater than count.")
            return []
        }
        
        var indexes : [Int] = []
        
        for _ in 1 ... count {
            
            var index = Int.random(range)
            while indexes.contains(index) { index = Int.random(range) }
            indexes.append(index)
        }
        
        return indexes
    }
}

enum Creature {
    case cat
    case goat
    
    func descriptor() -> String {
        switch self {
        case .cat: return "Cat"
        case .goat: return "Goat"
        }
    }
}

// First do the case where you stay with the first door you picked

let shouldDescribeEachRound = false
let numberOfTests = 1000
var keepTests : [Bool] = []
var switchTests : [Bool] = []

for shouldSwitch in 0...1 {
    
    for i in 0..<numberOfTests {
        
        // First, put a goat behind each door
        var doors : [Creature] = [.goat, .goat, .goat]
        
        // Now put a cat behind one of the doors instead
        let randomDoor = Int.random(3)
        doors[randomDoor] = .cat
        
        if shouldDescribeEachRound {
            print("\nCase \(i): \(doors[0].descriptor()), \(doors[1].descriptor()), \(doors[2].descriptor())")
        }
        
        // Get the contestant's pick
        var contestantPick = Int.random(3)
        if shouldDescribeEachRound {
            print("Contestant picks door \(contestantPick)")
        }
        
        // Determine which door Monty reveals to be a goat
        var montyReveal = 0
        if contestantPick == 0 {
            montyReveal = (doors[1] == .goat) ? 1 : 2
        } else if contestantPick == 1 {
            montyReveal = (doors[2] == .goat) ? 2 : 0
        } else if contestantPick == 2 {
            montyReveal = (doors[0] == .goat) ? 0 : 1
        }
        
        // Check to see if the door the contestant originally picked was a cat, and log the results
        if shouldDescribeEachRound {
            print("Monty opens door \(montyReveal) to reveal a \(doors[montyReveal].descriptor())")
        }
        
        // See if we should switch or not.
        if shouldSwitch == 0 {
            if shouldDescribeEachRound {
                print("Contestant chooses to keep the door. They open it to reveal ... a \(doors[contestantPick].descriptor())!")
            }
            
            keepTests.append(doors[contestantPick] == .cat)
        } else {
            
            // Contestant should pick the remaining door
            if contestantPick == 0 {
                contestantPick = montyReveal == 1 ? 2 : 1
            } else if contestantPick == 1 {
                contestantPick = montyReveal == 2 ? 2 : 0
            } else if contestantPick == 2 {
                contestantPick = montyReveal == 1 ? 0 : 1
            }
            
            if shouldDescribeEachRound {
                print("The contestant decides to switch to door \(contestantPick). They open it to reveal ... a \(doors[contestantPick].descriptor())!")
            }
            
            switchTests.append(doors[contestantPick] == .cat)
        }
    }
}

// Check how many keep tests were true
let correctKeepTests = keepTests.filter { $0 == true }
let correctKeepPercentage = Float(correctKeepTests.count) / Float(keepTests.count)
print("Out of \(keepTests.count) KEEP tests, \(correctKeepTests.count) were right: \(Int(correctKeepPercentage * 100)) percent.")

// Check how many switch tests were true
let correctSwitchTests = switchTests.filter { $0 == true }
let correctSwitchPercentage = Float(correctSwitchTests.count) / Float(switchTests.count)
print("Out of \(switchTests.count) SWITCH tests, \(correctSwitchTests.count) were right: \(Int(correctSwitchPercentage * 100)) percent.")
