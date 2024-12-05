//
//  User.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation
import UIKit

/// Singleton to manage user settings
final class User {
    // Shared instance for Singleton
    private static var shared : User?

    // Private initializer to restrict instantiation
    private init() {}

    
    static func getInstance() -> User {
        if shared == nil {
            shared = User()
        }
        return shared!
    }
    
    
    // Private properties
    private var isAdmin: Bool = false
    private var theme: Theme = .light

    // Getter for isAdmin
    func getAdminStatus() -> Bool {
        return isAdmin
    }

    // Setter for isAdmin
    func setAdminStatus(to status: Bool) {
        isAdmin = status
        print("Admin status updated to: \(isAdmin ? "Admin" : "User")")
    }

    // Getter for theme
    func getTheme() -> Theme {
        return theme
    }

    // Setter for theme
    func setTheme(to newTheme: Theme) {
        theme = newTheme
        applyTheme()
        print("Theme changed to: \(theme == .light ? "Light" : "Dark")")
    }
    // Function to apply the current theme globally
    private func applyTheme() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = (theme == .light) ? .light : .dark
        } else {
            print("Error: Unable to access window for theme application.")
        }
    }
}

/// Enum to represent theme options
enum Theme {
    case light
    case dark
}
