//
//  XcerptApp.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/27/23.
//

import SwiftUI


@main
struct Xcerpt2App: App {
    @StateObject var userPrefences = UserPreferences()
    @StateObject var bookStore = BookStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookStore)
                .environmentObject(userPrefences)
                .preferredColorScheme(userPrefences.darkMode ? .dark : .light)
        }
    }
}
