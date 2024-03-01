//
//  OverlayCollectionViewController.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import Foundation
import UIKit
import Combine
import SwiftUI
import NetworkingInterface

final class OverlayCollectionViewController: UIViewController {

    // MARK: - Properties
    var viewModel: OverlaysViewModel
    private var disposables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(overlaysViewModel: OverlaysViewModel) {
        self.viewModel = overlaysViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View properties
    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        button.tintColor = .lightGray
        return button
    }()
    
    // MARK: - View cycle
    override func viewDidLoad() {
        loadData()
        setupViews()
    }
    
    // MARK: - Setup view elements
    func setupViews() {
        self.title = "Overlays"
        self.navigationItem.rightBarButtonItem = closeButton
        self.navigationController?.isNavigationBarHidden = false
        self.configureCollectionView()
        self.view.accessibilityIdentifier = "OverlaysCollectionView"
        self.view.backgroundColor = .black
        
        // MARK: Navigation bar appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        navigationBarAppearance.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        // Calculate the size of each item to fit 4 in a row
        let width = (view.frame.size.width - (layout.minimumInteritemSpacing * 3) - 10) / 4
        layout.itemSize = CGSize(width: width, height: width)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        viewModel.overlayCollectionViewDataSource = OverlayCollectionViewDataSource(collectionView: collectionView, viewModel: viewModel)

        collectionView.delegate = viewModel.overlayCollectionViewDataSource
        collectionView.dataSource = viewModel.overlayCollectionViewDataSource
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
        
    }
    
    // MARK: - Data Loading
    func loadData() {
        viewModel.loadOverlays()
    }
    
    @objc func closeButtonTapped() {
        viewModel.onRequestDismiss(nil)
    }
}
