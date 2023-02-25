//
//  ThemeStore.swift
//  SwiftUIGame
//
//  Created by Ильдар Аглиуллов on 25.02.2023.
//

import SwiftUI

final class ThemeStore: ObservableObject {
    
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String { "ThemeStore" + name }
    
    let name: String
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty {
            getDefaultThemes()
        }
    }
}

private extension ThemeStore {
    
    func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodeThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            themes = decodeThemes
        }
    }
    
    func getDefaultThemes() {
        insertTheme(named: "Животные", emojis: "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐵", numbersOfPairsOfCards: 8, color: Color(rgbaColor: RGBAColor(255, 143, 20, 1)))
        insertTheme(named: "Продукты и еда", emojis: "🥐🥯🍞🥖🥨🧀🍳🧈🥞🧇🍗🌭🍔🍟🍕🥪", numbersOfPairsOfCards: 10, color: Color(rgbaColor: RGBAColor(86, 178, 62, 1)))
        insertTheme(named: "Транспорт", emojis: "🚗🚕🚙🚌🚎🏎🚓🚑🚒🚐🛻🚚🚛🚜🛴🚲🛵🏍", numbersOfPairsOfCards: 5, color: Color(rgbaColor: RGBAColor(248, 218, 9, 1)))
        insertTheme(named: "Сердца", emojis: "❤️🧡💛💚💙💜", numbersOfPairsOfCards: 4, color: Color(rgbaColor: RGBAColor(229, 108, 204, 1)))
        insertTheme(named: "Виды спорта", emojis: "⚽️🏀🏈⚾️🏐🎱🏓🏸🪁🤿🥊🥋🎽🛹🛼🛷⛸🥌🪂🎹🎻♟🎮", numbersOfPairsOfCards: 12)
        insertTheme(named: "Погода", emojis: "☀️⚡️🌧💧❄️", numbersOfPairsOfCards: 3, color: Color(rgbaColor: RGBAColor(37, 75, 240, 1)))
    }
}

extension ThemeStore {
    
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    func insertTheme(named name: String, emojis: String? = nil, numbersOfPairsOfCards: Int = 2, color: Color = Color(rgbaColor: RGBAColor(243, 63, 63, 1)), at index: Int = 0) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = Theme(name: name, emojis: emojis ?? "", numberOfPairsOfCards: numbersOfPairsOfCards, color: RGBAColor(color: color), id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
    
    func removeTheme(at index: Int) {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
    }
}
