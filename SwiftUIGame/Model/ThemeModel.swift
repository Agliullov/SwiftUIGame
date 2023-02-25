//
//  ThemeModel.swift
//  SwiftUIGame
//
//  Created by Ильдар Аглиуллов on 25.02.2023.
//

import Foundation

struct Theme: Codable, Identifiable, Hashable {
    var name: String
    var emojis: String
    var removedEmojis: String
    var numberOfPairsOfCards: Int
    var color: RGBAColor
    let id: Int
    
    init(name: String, emojis: String, numberOfPairsOfCards: Int, color: RGBAColor, id: Int) {
        self.name = name
        self.emojis = emojis
        self.removedEmojis = ""
        self.numberOfPairsOfCards = max(2, min(numberOfPairsOfCards, emojis.count))
        self.color = color
        self.id = id
    }
}
