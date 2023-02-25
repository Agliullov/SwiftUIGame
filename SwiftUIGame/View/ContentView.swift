//
//  ContentView.swift
//  SwiftUIGame
//
//  Created by Ильдар Аглиуллов on 24.02.2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var newGameButton: some View {
        Button {
            viewModel.startNewGame()
        } label: {
            Text("Новая игра")
        }
    }
    
    var body: some View {
        VStack {
            Text("Очков: \(viewModel.score)")
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65.0))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(Color(rgbaColor: viewModel.chosenTheme.color))
        }
        .padding()
        .navigationTitle("\(viewModel.chosenTheme.name)")
        .toolbar {
            newGameButton
        }
    }
}

struct CardView: View {
    
    var card: CardModel<String>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20.0)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel(theme: ThemeStore(named: "default").themes[0])
        ContentView(viewModel: viewModel).preferredColorScheme(.dark)
    }
}
