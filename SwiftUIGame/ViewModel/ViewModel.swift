//
//  ViewModel.swift
//  SwiftUIGame
//
//  Created by Ильдар Аглиуллов on 24.02.2023.
//

import Foundation

final class ViewModel: ObservableObject {
    
    @Published private var model: CardModel<String>
    
    let chosenTheme: Theme
    
    var cards: [CardModel<String>.Card] { model.cards }
    
    var score: Int { model.score }
    
    init(theme: Theme) {
        chosenTheme = theme
        model = ViewModel.createCardGame(of: chosenTheme)
    }
    
    static func createCardGame(of theme: Theme) -> CardModel<String> {
        let emojis = theme.emojis.map { String($0) }.shuffled()
        return CardModel(numberOfPairsOfCards: theme.numberOfPairsOfCards) { index in
            emojis[index]
        }
    }
}

extension ViewModel {
    
    func choose(_ card: CardModel<String>.Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        model = ViewModel.createCardGame(of: chosenTheme)
    }
}
