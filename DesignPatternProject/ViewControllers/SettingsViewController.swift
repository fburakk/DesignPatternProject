//
//  SettingsViewController.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var adminSwitch: UISwitch!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    // MARK: - UI Initialization
    // Initializes the UI with current settings from the Singleton
    private func initializeUI() {
        let user = User.getInstance()
        adminSwitch.isOn = user.getAdminStatus()
        themeSegmentedControl.selectedSegmentIndex = user.getTheme() == .light ? 0 : 1
    }
    
    // MARK: - Actions
    // Called when the theme segmented control value changes
    @IBAction func themeSegmentedControlChanged(_ sender: UISegmentedControl) {
        updateTheme(to: sender.selectedSegmentIndex)
    }
    
    // Called when the admin switch value changes
    @IBAction func adminSwitchChanged(_ sender: UISwitch) {
        updateAdminStatus(to: sender.isOn)
    }
    
    // MARK: - Helper Methods
    // Updates the theme in the Singleton and applies it
    private func updateTheme(to selectedIndex: Int) {
        let selectedTheme: Theme = selectedIndex == 0 ? .light : .dark
        User.getInstance().setTheme(to: selectedTheme)
    }
    
    // Updates the admin status in the Singleton
    private func updateAdminStatus(to isAdmin: Bool) {
        User.getInstance().setAdminStatus(to: isAdmin)
    }
}
