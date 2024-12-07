//
//  UploadProductViewController.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 26.11.2024.
//

import UIKit

class UploadProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    
    // MARK: - Properties
    private var selectedImage: UIImage?
    private let productContext = ProductContext(strategy: AddProduct())
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageViewTapGesture()
    }
    
    // MARK: - Setup Methods
    // Adds a tap gesture recognizer to the image view
    private func setupImageViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Image Picker Methods
    // Opens the image picker when the image view is tapped
    @objc private func imageViewTapped() {
        presentImagePicker()
    }
    
    // Presents the image picker to select an image from the photo library
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    // Handles the selected image and sets it to the image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImage = pickedImage
            imageView.image = pickedImage
        }
        dismiss(animated: true)
    }
    
    // Dismisses the image picker if the user cancels
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    // MARK: - Actions
    // Handles the upload button action to validate input and upload the product
    @IBAction func uploadButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "Please enter a product title.")
            return
        }
        
        guard let priceText = priceLabel.text, let price = Double(priceText) else {
            showAlert(message: "Please enter a valid price.")
            return
        }
        
        uploadProduct(name: title, price: price)
    }
    
    // Closes the upload screen when the close button is tapped
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Helper Methods
    // Validates and uploads the product using the ProductContext
    private func uploadProduct(name: String, price: Double) {
        productContext.setStrategy(AddProduct(name: name, price: price, image: selectedImage))
        productContext.executeStrategy { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.handleSuccessfulUpload()
            case .failure(let error):
                self.showAlert(message: "Failed to upload the product: \(error.localizedDescription)")
            }
        }
    }
    
    // Handles successful product upload, notifies observers, and dismisses the screen
    private func handleSuccessfulUpload() {
        showAlert(message: "Product uploaded successfully!") { [weak self] in
            self?.notifyProductObservers()
            self?.dismiss(animated: true)
        }
    }
    
    // Notifies observers about the new product
    private func notifyProductObservers() {
        productContext.setStrategy(FetchProducts())
        productContext.executeStrategy { result in
            switch result {
            case .success(let products):
                ProductSubject.shared.notifyObservers(with: products as! [Product])
            case .failure(let error):
                print("Failed to fetch products: \(error.localizedDescription)")
            }
        }
    }
    
    // Displays an alert with a message and an optional completion handler
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
}
