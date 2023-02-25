//
//  SwiftUIGameApp.swift
//  SwiftUIGame
//
//  Created by Ильдар Аглиуллов on 24.02.2023.
//

import SwiftUI

@main
struct SwiftUIGameApp: App {
    
    @StateObject var themeStore = ThemeStore(named: "default")
    
    var body: some Scene {
        WindowGroup {
            ThemeChooser()
                .environmentObject(themeStore)
        }
    }
}
