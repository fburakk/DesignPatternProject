//
//  UploadProductViewController.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 26.11.2024.
//

import UIKit

class UploadProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    
    private var selectedImage: UIImage?
    private let productContext = ProductContext(strategy: AddProduct())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageViewTapGesture()
    }
    
    // MARK: - Setup
    private func setupImageViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Image Picker
    @objc private func imageViewTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImage = pickedImage
            imageView.image = pickedImage
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    // MARK: - Actions
    @IBAction func uploadButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "Please enter a product title.")
            return
        }
        
        guard let priceText = priceLabel.text, let price = Double(priceText) else {
            showAlert(message: "Please enter a valid price.")
            return
        }
        
        // Update context with the AddProduct strategy
        productContext.setStrategy(AddProduct(name: title, price: price, image: selectedImage))
        productContext.executeStrategy { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.showAlert(message: "Product uploaded successfully!", completion: {
                    // Notify observers of the new product
                    let fetchProducts = FetchProducts()
                    self.productContext.setStrategy(fetchProducts)
                    self.productContext.executeStrategy { fetchResult in
                        switch fetchResult {
                        case .success(let products):
                            ProductObserver.shared.notifyObservers(with: products as! [Product])
                        case .failure(let error):
                            print("Failed to fetch products: \(error.localizedDescription)")
                        }
                    }
                    self.dismiss(animated: true) // Close the screen after success
                })
            case .failure(let error):
                self.showAlert(message: "Failed to upload the product: \(error.localizedDescription)")
            }
        }
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Helper Methods
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
}
