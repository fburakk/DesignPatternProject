//
//  CartViewController.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 26.11.2024.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var cartItems: [CartItemWithDetails] = [] // Updated to hold detailed cart items
    private let cartContext = CartContext(strategy: FetchCartItems()) // Initialize context with FetchCartItems strategy

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        fetchCartItems() // Fetch cart items on load
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCartItems()
    }
    
    private func fetchCartItems() {
        cartContext.setStrategy(FetchCartItems())
        cartContext.executeStrategy { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedItems):
                self.cartItems = fetchedItems as? [CartItemWithDetails] ?? []
                self.collectionView.reloadData()
            case .failure(let error):
                print("Failed to fetch cart items: \(error.localizedDescription)")
            }
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        // Define the size of an individual item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // Full width
            heightDimension: .absolute(45)       // Fixed height
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Define the group to stack items vertically
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), // Full width
            heightDimension: .estimated(45)      // Estimated height based on content
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // Define the section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.interGroupSpacing = 10 // Space between items

        // Create and return the layout
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        if cartItems.isEmpty {
            let alert = UIAlertController(title: "Cart Empty", message: "No items in the cart to order.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let shippingContext = ShippingContext(strategy: StandardShipping())
        let paymentContext = PaymentContext(strategy: CreditCardPayment())

        // Prepare details for the alert
        var message = "Your Cart Items:\n\n"
        var totalCost: Double = 0.0
        for item in cartItems {
            let shippingCost = shippingContext.calculateCost(for: 10) // Assume 10 as distance
            let itemCost = item.price + shippingCost
            totalCost += itemCost

            message += """
            Name: \(item.name)
            Price: $\(item.price)
            Shipping Method: \(shippingContext.getDescription())
            Payment Method: \(paymentContext.processPayment(amount: itemCost))
            
            """
        }
        message += "\nTotal Cost: $\(totalCost)"

        let alert = UIAlertController(title: "Order Summary", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            self?.deleteAllCartItems()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }
    // Helper function to delete all items from the cart
    private func deleteAllCartItems() {
        for item in cartItems {
            let removeFromCart = RemoveFromCart(productId: item.id)
            cartContext.setStrategy(removeFromCart)
            cartContext.executeStrategy { result in
                switch result {
                case .success:
                    print("Product \(item.name) removed from cart.")
                case .failure(let error):
                    print("Failed to remove product \(item.name): \(error.localizedDescription)")
                }
            }
        }
        
        cartItems.removeAll() // Clear the local array
        collectionView.reloadData() // Refresh the UI
        print("All items removed from the cart.")
    }
}

extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 // Single section for cart items
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartCell", for: indexPath) as? CartCell else {
            fatalError("Unable to dequeue CartCell")
        }
        let item = cartItems[indexPath.row]
        cell.configure(item)
        cell.delegate = self
        return cell
    }
}

extension CartViewController: CartCellDelegate {
    func closeButtonDidTap(_ id: String?) {
        guard let productId = id else { return }
        
        // Handle remove from cart logic
        let removeFromCart = RemoveFromCart(productId: productId)
        cartContext.setStrategy(removeFromCart)
        cartContext.executeStrategy { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print("Product removed from cart.")
                self.fetchCartItems() // Refresh cart after removal
            case .failure(let error):
                print("Failed to remove product from cart: \(error.localizedDescription)")
            }
        }
    }
}
