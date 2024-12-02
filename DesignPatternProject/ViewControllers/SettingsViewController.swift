//
//  SettingsViewController.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var adminSwitch: UISwitch!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize UI with Singleton values
        adminSwitch.isOn = User.shared.getAdminStatus()
        themeSegmentedControl.selectedSegmentIndex = User.shared.getTheme() == .light ? 0 : 1
    }

    @IBAction func themeSegmentedControlChanged(_ sender: UISegmentedControl) {
        let selectedTheme: Theme = sender.selectedSegmentIndex == 0 ? .light : .dark
        User.shared.setTheme(to: selectedTheme)
    }
    
    
    @IBAction func adminSwitchChanged(_ sender: UISwitch) {
        User.shared.setAdminStatus(to: sender.isOn)
    }
}
