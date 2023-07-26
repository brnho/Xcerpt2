//
//  UserPreferences.swift
//  Xcerpt
//
//  Created by Brian Ho on 6/1/23.
//

import SwiftUI

class UserPreferences: ObservableObject {
    var darkMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "DarkMode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DarkMode")
            objectWillChange.send()
        }
    }
}


