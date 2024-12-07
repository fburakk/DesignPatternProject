//
//  CartCell.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import UIKit

// Protocol defining the delegate for CartCell
protocol CartCellDelegate: AnyObject {
    // Method called when the close button is tapped
    func closeButtonDidTap(_ id: String?)
}

// CartCell represents a custom UICollectionViewCell for displaying cart items
class CartCell: UICollectionViewCell {

    // UI elements
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    weak var delegate: CartCellDelegate?
    private var id: String?
    
    // Configures the cell with data from a CartItemWithDetails object
    func configure(_ dataSource: CartItemWithDetails) {
        titleLabel.text = dataSource.name
        priceLabel.text = "\(dataSource.price) USD"
        self.id = dataSource.id
        setupUI()
    }
    
    private func setupUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
    }
    
    // Action triggered when the close button is tapped
    // Notifies the delegate about the event
    @IBAction func closeButtonTapped(_ sender: Any) {
        delegate?.closeButtonDidTap(id) // Pass the cart item's ID to the delegate
    }
}
