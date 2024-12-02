//
//  ProductDetailViewController.swift
//  DesignPatternProject
//

import UIKit
import UserNotifications

class ProductDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shippingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var paymentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var discountButton: UIBarButtonItem!

    // MARK: - Properties
    var product: Product?
    private var observerId: UUID?
    private let cartContext = CartContext(strategy: AddToCart())
    private let shippingContext = ShippingContext(strategy: StandardShipping())
    private let paymentContext = PaymentContext(strategy: CreditCardPayment())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeDiscounts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideDiscountButtonIfNeeded()
    }

    // MARK: - UI Setup
    private func setupUI() {
        guard let product = product else { return }

        titleLabel.text = product.name ?? "Unknown Product"
        priceLabel.text = "$\(product.price)"

        if let imageData = product.imageData {
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = UIImage(systemName: "photo") // Placeholder
        }

        // Configure segmented controls with default values
        shippingSegmentedControl.selectedSegmentIndex = 0
        paymentSegmentedControl.selectedSegmentIndex = 0
    }
    
    private func hideDiscountButtonIfNeeded() {
        // Hide discount button if we are customer
        discountButton.isHidden = !(User.shared.getAdminStatus())
    }

    // MARK: - Observer for Discounts
    private func observeDiscounts() {
        guard let product = product else { return }
        DiscountObserver.shared.addObserver(self) { [weak self] productId, discount in
            guard let self = self, productId == product.id else { return }
            self.priceLabel.text = "$\(product.price - discount)"
            self.scheduleLocalNotification(for: product.name ?? "Product", discount: discount)
        }
    }

    // MARK: - Local Notification
    private func scheduleLocalNotification(for productName: String, discount: Double) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Discount Alert!"
                content.body = "\(productName) is now discounted by $\(discount). Don't miss out!"
                content.sound = .default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                center.add(request) { error in
                    if let error = error {
                        print("Failed to schedule notification: \(error)")
                    }
                }
            } else {
                print("Notification permission denied.")
            }
        }
    }

    // MARK: - Actions
    @IBAction func discountButtonTapped(_ sender: Any) {
        guard let product = product else { return }

        // Simulate adding a discount for the product
        let discount = 10.0 // Example discount value
        DiscountObserver.shared.notifyObservers(for: product.id ?? "", discount: discount)
    }

    @IBAction func addToCartButtonTapped(_ sender: Any) {
        guard let product = product else { return }

        // Update shipping and payment contexts
        let selectedShippingIndex = shippingSegmentedControl.selectedSegmentIndex
        let selectedPaymentIndex = paymentSegmentedControl.selectedSegmentIndex

        let shippingStrategy: ShippingMethodStrategy = (selectedShippingIndex == 0) ? StandardShipping() : ExpressShipping()
        var paymentStrategy: PaymentMethodStrategy = CreditCardPayment()
        
        switch selectedPaymentIndex {
        case 0:
            paymentStrategy = CreditCardPayment()
        case 1:
            paymentStrategy = PayPalPayment()
        case 2:
            paymentStrategy = ApplePayPayment()
        default:
            break
        }
        

        shippingContext.setStrategy(shippingStrategy)
        paymentContext.setStrategy(paymentStrategy)

        let selectedShipping = shippingContext.getDescription()
        let selectedPayment = paymentContext.processPayment(amount: product.price)

        // Add product to the cart using the cart context
        cartContext.setStrategy(AddToCart(productId: product.id ?? "",
                                          shippingMethod: selectedShipping,
                                          paymentMethod: selectedPayment))
        cartContext.executeStrategy { result in
            switch result {
            case .success:
                self.showAlert(message: "Product added to cart!")
            case .failure(let error):
                self.showAlert(message: "Failed to add product to cart: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Helper Methods
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    deinit {
        DiscountObserver.shared.removeObserver(self)
    }
}
