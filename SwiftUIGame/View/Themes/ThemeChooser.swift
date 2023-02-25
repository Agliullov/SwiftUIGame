//
//  ThemeChooser.swift
//  SwiftUIGame
//
//  Created by Ильдар Аглиуллов on 25.02.2023.
//

import SwiftUI

struct ThemeChooser: View {
    
    @EnvironmentObject var store: ThemeStore
    @State private var games = [Theme: ViewModel]()
    @State private var editMode: EditMode = .inactive
    @State private var themeToEdit: Theme?
    
    private var addThemeButton: some View {
        Button {
            store.insertTheme(named: "Добавить")
            themeToEdit = store.themes.first
        } label: {
            Image(systemName: "plus")
                .foregroundColor(.blue)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes.filter { $0.emojis.count > 1 }) { theme in
                    NavigationLink(destination: getDestination(for: theme)) {
                        themeRow(for: theme)
                    }
                    .gesture(editMode == .active ? tapToOpenThemeEditor(for: theme) : nil)
                }
                .onDelete { indexSet in
                    indexSet.forEach { store.removeTheme(at: $0) }
                }
                .onMove { fromOffsets, toOffset in
                    store.themes.move(fromOffsets: fromOffsets, toOffset: toOffset)
                }
            }
            .listStyle(.inset)
            .navigationTitle("Запоминалка")
            .sheet(item: $themeToEdit) {
                removeNewThemeOnDismissIfInvalid()
            } content: { theme in
                ThemeEditor(theme: $store.themes[theme])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { addThemeButton }
                ToolbarItem { EditButton() }
            }
            .environment(\.editMode, $editMode)
        }
        .stackNavigationViewStyleIfiPad()
        .onChange(of: store.themes) { newThemes in
            updateGames(to: newThemes)
        }
    }
    
    private func themeRow(for theme: Theme) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .foregroundColor(Color(rgbaColor: theme.color))
                .font(.system(size: 25.0))
                .bold()
            HStack {
                if theme.numberOfPairsOfCards == theme.emojis.count {
                    Text("Все из \(theme.emojis)")
                } else {
                    Text("\(String(theme.numberOfPairsOfCards)) пар из \(theme.emojis)")
                }
            }
            .lineLimit(1)
        }
    }
    
    private func getDestination(for theme: Theme) -> some View {
        if games[theme] == nil {
            let newGame = ViewModel(theme: theme)
            games.updateValue(newGame, forKey: theme)
            return ContentView(viewModel: newGame)
        }
        return ContentView(viewModel: games[theme]!)
    }
    
    private func removeNewThemeOnDismissIfInvalid() {
        if let newButtonInvalidTheme = store.themes.first {
            if newButtonInvalidTheme.emojis.count < 2 {
                store.removeTheme(at: 0)
            }
        }
    }
    
    private func tapToOpenThemeEditor(for theme: Theme) -> some Gesture {
        TapGesture()
            .onEnded {
                themeToEdit = store.themes[theme]
            }
    }
    
    private func updateGames(to newThemes: [Theme]) {
        store.themes.filter { $0.emojis.count >= 2 }.forEach { theme in
            if !newThemes.contains(theme) {
                store.themes.remove(theme)
            }
        }
    }
}

//struct ThemeChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeChooser()
//    }
//}
