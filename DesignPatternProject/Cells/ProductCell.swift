//
//  ProductCell.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import UIKit

// ProductCell represents a custom UICollectionViewCell for displaying product details
class ProductCell: UICollectionViewCell {
    
    // UI elements
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // Configures the cell with data from a Product object
    func configure(_ dataSource: Product) {
        if let imageData = dataSource.imageData {
            imageView.image = UIImage(data: imageData)
        }
        titleLabel.text = dataSource.name
        priceLabel.text = "\(dataSource.price) USD"
        
        setupUI()
    }
    
    private func setupUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
    }
}
