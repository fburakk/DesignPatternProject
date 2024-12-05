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
    
    private var products: [Product] = []
    private var observerId: UUID?
    private let sortContext = SortContext(strategy: SortAlphabetically())
    private let productContext = ProductContext(strategy: FetchProducts())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchProducts()
        
        // Add observer for product updates
        observerId = ProductSubject.shared.addObserver(self) { [weak self] updatedProducts in
            self?.products = updatedProducts
            self?.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideUploadButtonIfNeeded()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    private func fetchProducts() {
        productContext.executeStrategy { [weak self] result in
            switch result {
            case .success(let fetchedProducts):
                self?.products = fetchedProducts as! [Product]
                self?.collectionView.reloadData()
            case .failure(let error):
                print("Error fetching products: \(error.localizedDescription)")
            }
        }
    }
    
    private func hideUploadButtonIfNeeded() {
        // Hide upload button if we are customer
        uploadProductButton.isHidden = !(User.getInstance().getAdminStatus())
    }
    
    deinit {
        if let observerId = observerId {
            ProductSubject.shared.removeObserver(with: observerId)
        }
    }
    
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
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProductDetail" {
            if let productDetailVC = segue.destination as? ProductDetailViewController,
               let selectedProduct = sender as? Product {
                productDetailVC.product = selectedProduct
            }
        }
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        let sortOptions: [(String, SortStrategy)] = [
            ("Price: Low to High", SortByPriceLowToHigh()),
            ("Price: High to Low", SortByPriceHighToLow()),
            ("Alphabetical", SortAlphabetically())
        ]
        
        let alert = UIAlertController(title: "Sort Products", message: "Choose a sorting option", preferredStyle: .actionSheet)
        
        for (title, strategy) in sortOptions {
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { _ in
                self.applySortStrategy(strategy)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func applySortStrategy(_ strategy: SortStrategy) {
        sortContext.setStrategy(strategy)
        products = sortContext.sortProducts(products)
        collectionView.reloadData()
    }
}

extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 // Single section for products
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
