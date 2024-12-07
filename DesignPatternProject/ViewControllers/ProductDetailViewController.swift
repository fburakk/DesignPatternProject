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
    private let cartContext = CartContext(strategy: AddToCart())
    private let shippingContext = ShippingContext(strategy: StandardShipping())
    private let paymentContext = PaymentContext(strategy: CreditCardPayment())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDiscountObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toggleDiscountButtonVisibility()
    }

    // MARK: - UI Setup
    private func setupUI() {
        guard let product = product else { return }

        titleLabel.text = product.name ?? "Unknown Product"
        priceLabel.text = "$\(product.price)"

        // Set product image or placeholder
        imageView.image = product.imageData.flatMap { UIImage(data: $0) } ?? UIImage(systemName: "photo")

        // Configure default segmented control values
        shippingSegmentedControl.selectedSegmentIndex = 0
        paymentSegmentedControl.selectedSegmentIndex = 0
    }
    
    // Hides or shows the discount button based on admin status
    private func toggleDiscountButtonVisibility() {
        discountButton.isHidden = !User.getInstance().getAdminStatus()
    }

    // MARK: - Discount Observer
    private func setupDiscountObserver() {
        guard let product = product else { return }
        DiscountSubject.shared.addObserver(self) { [weak self] productId, discount in
            guard let self = self, productId == product.id else { return }
            self.updatePriceLabel(discount: discount)
            self.scheduleDiscountNotification(for: product.name ?? "Product", discount: discount)
        }
    }
    
    private func updatePriceLabel(discount: Double) {
        guard let product = product else { return }
        let discountedPrice = product.price - discount
        priceLabel.text = "$\(discountedPrice)"
    }

    // MARK: - Local Notification
    private func scheduleDiscountNotification(for productName: String, discount: Double) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            guard granted, error == nil else {
                print("Notification permission denied or failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = "Discount Alert!"
            content.body = "\(productName) is now discounted by $\(discount). Don't miss out!"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to schedule notification: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Actions
    @IBAction func discountButtonTapped(_ sender: Any) {
        guard let product = product else { return }
        let discount = 10.0 // Example discount value
        DiscountSubject.shared.notifyObservers(for: product.id ?? "", discount: discount)
    }

    @IBAction func addToCartButtonTapped(_ sender: Any) {
        guard let product = product else { return }

        let shippingStrategy = selectedShippingStrategy()
        let paymentStrategy = selectedPaymentStrategy()

        shippingContext.setStrategy(shippingStrategy)
        paymentContext.setStrategy(paymentStrategy)

        let selectedShipping = shippingContext.getDescription()
        let selectedPayment = paymentContext.processPayment(amount: product.price)

        addToCart(productId: product.id ?? "", shippingMethod: selectedShipping, paymentMethod: selectedPayment)
    }

    // Returns the selected shipping strategy based on the segmented control index
    private func selectedShippingStrategy() -> ShippingMethodStrategy {
        return shippingSegmentedControl.selectedSegmentIndex == 0 ? StandardShipping() : ExpressShipping()
    }

    // Returns the selected payment strategy based on the segmented control index
    private func selectedPaymentStrategy() -> PaymentMethodStrategy {
        switch paymentSegmentedControl.selectedSegmentIndex {
        case 0:
            return CreditCardPayment()
        case 1:
            return PayPalPayment()
        case 2:
            return ApplePayPayment()
        default:
            return CreditCardPayment() // Default to credit card
        }
    }

    // Adds a product to the cart using the current context
    private func addToCart(productId: String, shippingMethod: String, paymentMethod: String) {
        cartContext.setStrategy(AddToCart(productId: productId, shippingMethod: shippingMethod, paymentMethod: paymentMethod))
        cartContext.executeStrategy { [weak self] result in
            guard let self = self else { return }
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
        DiscountSubject.shared.removeObserver(self)
    }
}
