//
//  ContentView.swift
//  SwiftUIGame
//
//  Created by Ильдар Аглиуллов on 24.02.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var changeToggle: Bool
    
    var body: some View {
        
        NavigationView {
            VStack {
                NavigationLink(destination: DetailsView()) {
                    Text("Go details!")
                }
                Text("World Time").font(.system(size: 30))
                Toggle(isOn: $changeToggle) {
                    Text("Change toggle")
                }
            }.navigationBarTitle(Text("World Time"), displayMode: .large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(changeToggle: false)
    }
}
