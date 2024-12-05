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
        adminSwitch.isOn = User.getInstance().getAdminStatus()
        themeSegmentedControl.selectedSegmentIndex = User.getInstance().getTheme() == .light ? 0 : 1
    }

    @IBAction func themeSegmentedControlChanged(_ sender: UISegmentedControl) {
        let selectedTheme: Theme = sender.selectedSegmentIndex == 0 ? .light : .dark
        User.getInstance().setTheme(to: selectedTheme)
    }
    
    
    @IBAction func adminSwitchChanged(_ sender: UISwitch) {
        User.getInstance().setAdminStatus(to: sender.isOn)
    }
}
