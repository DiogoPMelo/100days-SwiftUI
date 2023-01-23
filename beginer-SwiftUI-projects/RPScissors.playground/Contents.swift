import Cocoa

// day 35

struct QuestionAnswer: Equatable {
    var question: String
    var answer: Int
    
}

var qa1 = QuestionAnswer(question: "ola", answer: 30)
var qa2 = QuestionAnswer(question: "ola", answer: 30)
print(qa1 == qa2)



// from day 25
enum Jogada: Int {
    case rock, paper, scissors
}

enum Result {
    case win, draw, loss
}

func result (_ cpu: Jogada, vs player: Jogada) -> Result {
    if cpu.rawValue == player.rawValue {
        return Result.draw
    } else if cpu.rawValue == player.rawValue + 1 || cpu.rawValue == player.rawValue - 2 {
        return Result.loss
    } else {
        return Result.win
    }
    }

for cpu in 0...2 {
    for player in 0...2 {
        let playerJ = Jogada(rawValue: player)!
        let cpuJ = Jogada(rawValue: cpu)!
        print("\(playerJ) vs \(cpuJ): \(result(cpuJ, vs: playerJ))")
        
    }
}
