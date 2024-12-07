//
//  ProductsViewController.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import UIKit

class ProductsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadProductButton: UIBarButtonItem!
    
    private var products: [Product] = [] // Holds the list of products to display
    private var observerId: UUID? // Unique ID for product updates observer
    private let sortContext = SortContext(strategy: SortAlphabetically()) // Default sorting strategy
    private let productContext = ProductContext(strategy: FetchProducts()) // Fetch products strategy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchProducts()
        observeProductUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toggleUploadButtonVisibility()
    }
    
    // MARK: - Setup Methods
    
    // Configures the collection view delegate, data source, and layout
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    // Observes product updates via ProductSubject
    private func observeProductUpdates() {
        observerId = ProductSubject.shared.addObserver(self) { [weak self] updatedProducts in
            self?.products = updatedProducts
            self?.collectionView.reloadData()
        }
    }
    
    // Fetches products using the current strategy in ProductContext
    private func fetchProducts() {
        productContext.executeStrategy { [weak self] result in
            switch result {
            case .success(let fetchedProducts):
                self?.products = fetchedProducts as! [Product]
                self?.collectionView.reloadData()
            case .failure(let error):
                self?.showAlert(message: "Error fetching products: \(error.localizedDescription)")
            }
        }
    }
    
    // Hides the upload button if the user is not an admin
    private func toggleUploadButtonVisibility() {
        uploadProductButton.isHidden = !User.getInstance().getAdminStatus()
    }
    
    deinit {
        // Remove observer when the view controller is deinitialized
        if let observerId = observerId {
            ProductSubject.shared.removeObserver(with: observerId)
        }
    }
    
    // MARK: - Collection View Layout
    
    // Creates and returns a compositional layout for the collection view
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0)
        section.interGroupSpacing = 10
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Sorting and Actions
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        showSortOptions()
    }
    
    // Displays sorting options to the user in an action sheet
    private func showSortOptions() {
        let sortOptions: [(String, SortStrategy)] = [
            ("Price: Low to High", SortByPriceLowToHigh()),
            ("Price: High to Low", SortByPriceHighToLow()),
            ("Alphabetical", SortAlphabetically())
        ]
        
        let alert = UIAlertController(title: "Sort Products", message: "Choose a sorting option", preferredStyle: .actionSheet)
        
        for (title, strategy) in sortOptions {
            alert.addAction(UIAlertAction(title: title, style: .default) { _ in
                self.applySortStrategy(strategy)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // Applies the selected sorting strategy and reloads the collection view
    private func applySortStrategy(_ strategy: SortStrategy) {
        sortContext.setStrategy(strategy)
        products = sortContext.sortProducts(products)
        collectionView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProductDetail",
           let productDetailVC = segue.destination as? ProductDetailViewController,
           let selectedProduct = sender as? Product {
            productDetailVC.product = selectedProduct
        }
    }
    
    // MARK: - Helper Methods
    
    // Displays an alert with a message
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Collection View Delegate and Data Source

extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            fatalError("Unable to dequeue ProductCell")
        }
        let product = products[indexPath.row]
        cell.configure(product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: "ShowProductDetail", sender: selectedProduct)
    }
}
