//
//  User.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation
import UIKit

// Singleton to manage user settings
// This class ensures only one instance exists and provides global access to it.
final class User {
    // The shared instance of the User class
    private static var shared: User?
    
    // Private initializer to prevent instantiation from outside
    private init() {}
    
    // Provides the single shared instance of the User class
    static func getInstance() -> User {
        if shared == nil {
            shared = User() // Create the instance if it doesn't exist
        }
        return shared!
    }
    
    private var isAdmin: Bool = false
    private var theme: Theme = .light
    
    // Retrieves the admin status
    func getAdminStatus() -> Bool {
        return isAdmin
    }
    
    // Updates the admin status
    func setAdminStatus(to status: Bool) {
        isAdmin = status
        print("Admin status updated to: \(isAdmin ? "Admin" : "User")")
    }
    
    // Retrieves the current theme
    func getTheme() -> Theme {
        return theme
    }
    
    // Updates the theme and applies it to the application
    func setTheme(to newTheme: Theme) {
        theme = newTheme
        applyTheme()
        print("Theme changed to: \(theme == .light ? "Light" : "Dark")")
    }
    
    // Applies the current theme to the application's user interface
    private func applyTheme() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = (theme == .light) ? .light : .dark
        } else {
            print("Error: Unable to access window for theme application.")
        }
    }
}

// Enum to represent theme options
enum Theme {
    case light
    case dark
}
