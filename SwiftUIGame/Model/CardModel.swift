//
//  CardModel.swift
//  SwiftUIGame
//
//  Created by Ильдар Аглиуллов on 24.02.2023.
//

import Foundation

struct CardModel<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    
    private(set) var score = 0
    
    private var indexOfTheOneAneOnlyFaceUpCard: Int?
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            let chosenTime = Date()
            if let potentialMatchIndex = indexOfTheOneAneOnlyFaceUpCard {
                let usedTime = Int(chosenTime.timeIntervalSince(cards[potentialMatchIndex].chosenTime!))
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2 * max(10 - usedTime, 1)
                } else {
                    if cards[chosenIndex].isAlreadySeen {
                        score -= 1 * max(10 - usedTime, 1)
                    }
                    if cards[potentialMatchIndex].isAlreadySeen {
                        score -= 1 * max(10 - usedTime, 1)
                    }
                }
                cards[chosenIndex].isAlreadySeen = true
                cards[potentialMatchIndex].isAlreadySeen = true
                indexOfTheOneAneOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                cards[chosenIndex].chosenTime = chosenTime
                indexOfTheOneAneOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp = true
        }
    }
}

extension CardModel {
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isAlreadySeen: Bool = false
        let content: CardContent
        var chosenTime: Date?
        var id: Int
    }
}
