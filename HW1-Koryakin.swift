import Foundation

func collapse(_ str: String) -> String {
    var currentLetter: Character?
    var count = 0
    var resultingString = ""
    
    func appendPlease(_: Character, with count: Int, to resultingString: inout String) {
            resultingString += String(currentLetter!)
            resultingString += count == 1 ? "" : String(count)
    }
    
    for char in str {
        // Встречаем первую букву
        if currentLetter == nil {
            currentLetter = char
            count = 1
        } else {
            // Второй и последующие разы
            if char == currentLetter {
                count += 1
            } else {
                appendPlease(currentLetter!, with: count, to: &resultingString)
                count = 1
                currentLetter = char
            }
        }
    }
    appendPlease(currentLetter!, with: count, to: &resultingString)
    return resultingString
}

print("Задание №1")
print(collapse("AABBBCRFFA"))
print("A2B3CRF2A")
if collapse("AABBBCRFFA") == "A2B3CRF2A" {
    print("№1 👍")
}
// Количество простых чисел меньше N
func numberOfPrimesLessThan(_ number: Int) -> Int {
    var result = [Int]()
    var previousNumbers = [Int]()
    for currentNumber in 2...number {
        var counter = 0
        for prevNum in previousNumbers {
            if currentNumber % prevNum == 0 && prevNum != 1 {
                counter = counter + 1
            }
        }
        if counter == 0 {
            result.append(currentNumber)
        }
        previousNumbers.append(currentNumber)
    }
    return result.count
}

// 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 - 10 чисел для N=30
print("\nЗадание #2\n\(numberOfPrimesLessThan(30))")
if numberOfPrimesLessThan(30) == 10 {
    print("№2 👍")
}


let info = [
    "Chelsea": ["Kante", "Lukaku", "Werner"],
    "PSG": ["Messi", "Neymar", "Mbappe"],
    "Manchester City": ["Grealish", nil, "Sterling"]
]

func bestPlayers(from playersInfo: [String: [String?]]) -> [String] {
    var players: [String] = []
    
    for (key, _) in playersInfo {
        guard let info = playersInfo[key] else { continue }
        
        players.append(contentsOf:
                        info.compactMap {$0?.count ?? 0 > 5 ? $0 : nil
        }
        )
    }
    
    return players.sorted(by: <)
}

let correctAnswer = ["Grealish", "Lukaku", "Mbappe", "Neymar", "Sterling", "Werner"]

print("\nЗадание №3")
print(bestPlayers(from: info))
print(correctAnswer)

if correctAnswer == bestPlayers(from: info) {
      print("№3 👍")
}
