import Foundation

func collapse(_ str: String) -> String {
    var currentLetter: Character?
    var count = 0
    var resultingString = ""
    
    func appendIfNeeded(_ charToAppend: Character?, with count: Int, to resultingString: inout String) {
        guard let unwrappedChar = charToAppend else { return }
        resultingString += String(unwrappedChar)
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
                appendIfNeeded(currentLetter, with: count, to: &resultingString)
                count = 1
                currentLetter = char
            }
        }
    }
    appendIfNeeded(currentLetter, with: count, to: &resultingString)
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
    guard number > 2 else { return 0}
    guard number > 3 else { return 1}

    var currentIndex = 0
    var currentPrimeNum = 2
    var numbers: [Int] = Array(2...number)
    
    while currentPrimeNum * currentPrimeNum <= number {
        numbers = numbers.filter {
            (($0 % currentPrimeNum) != 0) || ($0 < 2*currentPrimeNum)
        }
        currentIndex += 1
        currentPrimeNum = numbers[currentIndex]
    }
    return numbers.count
}
print("\nЗадание #2\n\(numberOfPrimesLessThan(30))")
let primesUnder100 = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
assert(numberOfPrimesLessThan(100) == primesUnder100.count)
assert(numberOfPrimesLessThan(30) == 10)
assert(numberOfPrimesLessThan(4) == 2)
assert(numberOfPrimesLessThan(3) == 1)
assert(numberOfPrimesLessThan(2) == 0)
assert(numberOfPrimesLessThan(1) == 0)
print("№2 👍")

let info = [
    "Chelsea": ["Kante", "Lukaku", "Werner"],
    "PSG": ["Messi", "Neymar", "Mbappe"],
    "Manchester City": ["Grealish", nil, "Sterling"]
]

func bestPlayers(from playersInfo: [String: [String?]]) -> [String] {
    return playersInfo
        .values
        .flatMap {
            $0
                .compactMap { $0 }
                .filter { $0.count > 5 }
        }.sorted(by: <)
}

let correctAnswer = ["Grealish", "Lukaku", "Mbappe", "Neymar", "Sterling", "Werner"]

print("\nЗадание №3")
print(bestPlayers(from: info))
print(correctAnswer)

if correctAnswer == bestPlayers(from: info) {
      print("№3 👍")
}
