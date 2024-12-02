//
//  CartCell.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func closeButtonDidTap(_ id: String?)
}

class CartCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    weak var delegate: CartCellDelegate?
    private var id: String?
    
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
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        delegate?.closeButtonDidTap(id)
    }
}
