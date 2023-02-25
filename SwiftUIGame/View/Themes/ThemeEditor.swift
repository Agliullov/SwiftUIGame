//
//  ThemeEditor.swift
//  SwiftUIGame
//
//  Created by Ильдар Аглиуллов on 25.02.2023.
//

import SwiftUI

struct ThemeEditor: View {
    
    @State private var name: String
    @State private var candidateEmojis: String
    @State private var emojiToAdd = ""
    
    @State var numberOfPairs: Int
    @State var chosenColor: Color = .red

    @Binding var theme: Theme
    
    @Environment(\.presentationMode) private var presentationMode

    init(theme: Binding<Theme>) {
        self._theme = theme
        self._name = State(initialValue: theme.wrappedValue.name)
        self._candidateEmojis = State(initialValue: theme.wrappedValue.emojis)
        self._numberOfPairs = State(initialValue: theme.wrappedValue.numberOfPairsOfCards)
        self._chosenColor = State(initialValue: Color(rgbaColor: theme.wrappedValue.color))
    }
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                removeEmojiSection
                addEmojiSection
                cardPairSection
                colorSection
            }
            .navigationTitle("\(name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { cancelButton }
                ToolbarItem { doneButton }
            }
        }
    }
    
    private var doneButton: some View {
        Button("Готово") {
            if presentationMode.wrappedValue.isPresented && candidateEmojis.count >= 2 {
                saveAllEdits()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var cancelButton: some View {
        Button("Отмена") {
            if presentationMode.wrappedValue.isPresented {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var nameSection: some View {
        Section {
            TextField("Название темы", text: $name)
        } header: {
            Text("Название темы")
        }
    }
    
    
    private var removeEmojiSection: some View {
        let header = HStack {
            Text("Эмодзи")
            Spacer()
            Text("Удалить")
        }
        
        return Section {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 20.0))]) {
                ForEach(candidateEmojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                if candidateEmojis.count > 2 {
                                    candidateEmojis.removeAll { String($0) == emoji }
                                }
                            }
                        }
                }
            }
        } header: {
            header
        }
    }
    
    private var addEmojiSection: some View {
        Section {
            TextField("Эмодзи", text: $emojiToAdd)
                .onChange(of: emojiToAdd) { newValue in
                    addToCandidateEmoji(newValue)
                }
        } header: {
            Text("Добавить эмодзи")
        }
    }
    
    private var cardPairSection: some View {
        Section {
            Stepper("\(numberOfPairs) пар", value: $numberOfPairs, in: candidateEmojis.count < 2 ? 2...2 : 2...candidateEmojis.count)
                .onChange(of: candidateEmojis) { newValue in
                    numberOfPairs = max(2, min(numberOfPairs, candidateEmojis.count))
                }
        } header: {
            Text("Количество пар")
        }
    }
    
    private var colorSection: some View {
        if #available(iOS 15.0, *) {
            return Section("ЦВЕТ") {
                ColorPicker("Текущий цвет", selection: $chosenColor, supportsOpacity: false)
                    .foregroundColor(chosenColor)
            }
        } else {
            return Section {
                ColorPicker("", selection: $chosenColor, supportsOpacity: false)
                    .foregroundColor(chosenColor)
            } header: {
                Text("Текущий цвет")
            }
        }
    }
    
    
    
    private func saveAllEdits() {
        theme.name = name
        theme.emojis = candidateEmojis
        theme.numberOfPairsOfCards = min(numberOfPairs, candidateEmojis.count)
        theme.color = RGBAColor(color: chosenColor)
    }
    
    private func addToCandidateEmoji(_ emojis: String) {
        withAnimation {
            candidateEmojis = (emojis + candidateEmojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
}

//struct ThemeEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeEditor()
//    }
//}
