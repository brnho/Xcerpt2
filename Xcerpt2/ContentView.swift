//
//  ContentView.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/30/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .home
    enum Tab {
        case home
        case randomExcerpts
    }
    
    var body: some View {
        TabView(selection: $selection) {
            BookHome()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)
            BookRandomExcerpts()
                .tabItem {
                    Label("Shuffle", systemImage: "shuffle")
                }
                .tag(Tab.randomExcerpts)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BookStore())
            .environmentObject(UserPreferences())
    }
}
