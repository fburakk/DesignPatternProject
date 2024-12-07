//
//  CartViewController.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 26.11.2024.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var cartItems: [CartItemWithDetails] = [] // Holds detailed cart items
    private let cartContext = CartContext(strategy: FetchCartItems()) // Initialize context with FetchCartItems strategy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchCartItems() // Fetch cart items on load
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCartItems() // Refresh cart items when view appears
    }
    
    // Sets up the collection view delegate, data source, and layout
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    // Fetches cart items using the FetchCartItems strategy
    private func fetchCartItems() {
        cartContext.setStrategy(FetchCartItems())
        executeCartStrategy { [weak self] result in
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
    
    // Creates a compositional layout for the collection view
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(45))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(45))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.interGroupSpacing = 10
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // Executes the current strategy set in CartContext
    private func executeCartStrategy(completion: @escaping (Result<Any, Error>) -> Void) {
        cartContext.executeStrategy(completion: completion)
    }
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        if cartItems.isEmpty {
            showAlert(title: "Cart Empty", message: "No items in the cart to order.")
            return
        }
        
        let shippingContext = ShippingContext(strategy: StandardShipping())
        let paymentContext = PaymentContext(strategy: CreditCardPayment())
        
        var message = "Your Cart Items:\n\n"
        var totalCost: Double = 0.0
        
        // Calculate the total cost and prepare the order summary
        for item in cartItems {
            let shippingCost = shippingContext.calculateCost(for: 10)
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
        
        showAlert(
            title: "Order Summary",
            message: message,
            actions: [
                UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
                    self?.deleteAllCartItems()
                }),
                UIAlertAction(title: "Cancel", style: .cancel)
            ]
        )
    }
    
    // Shows an alert with a title, message, and optional actions
    private func showAlert(title: String, message: String, actions: [UIAlertAction] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            actions.forEach { alert.addAction($0) }
        }
        present(alert, animated: true)
    }
    
    // Deletes all items from the cart
    private func deleteAllCartItems() {
        for item in cartItems {
            removeItemFromCart(item)
        }
        cartItems.removeAll() // Clear the local array
        collectionView.reloadData() // Refresh the UI
        print("All items removed from the cart.")
    }
    
    // Removes a specific item from the cart
    private func removeItemFromCart(_ item: CartItemWithDetails) {
        let removeFromCart = RemoveFromCart(productId: item.id)
        cartContext.setStrategy(removeFromCart)
        executeCartStrategy { result in
            switch result {
            case .success:
                print("Product \(item.name) removed from cart.")
            case .failure(let error):
                print("Failed to remove product \(item.name): \(error.localizedDescription)")
            }
        }
    }
}

extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
        
        // Remove the item from the cart
        let removeFromCart = RemoveFromCart(productId: productId)
        cartContext.setStrategy(removeFromCart)
        executeCartStrategy { [weak self] result in
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
