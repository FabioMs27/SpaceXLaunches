//
//  LaunchesViewController.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 06.10.2024.
//

import UIKit
import UIKitNavigation

class LaunchesViewController: UICollectionViewController {
    
    @UIBindable var viewModel: LaunchesViewModel
    
    var dataSource: UICollectionViewDiffableDataSource<Launches.Output.Section, Launches.Output.Item>!
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Past Launches"
        searchController.searchBar.searchTextField.bind(text: $viewModel.searchQuery)
        definesPresentationContext = true
        return searchController
    }()
    
    init(viewModel: LaunchesViewModel) {
        self.viewModel = viewModel
        super.init(
            collectionViewLayout: UICollectionViewCompositionalLayout.list(
                using: UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            )
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        
        observe { [weak self] in
            guard let self else { return }
            dataSource.apply(.init(viewModel: viewModel))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await viewModel.fetchPastLaunchesAllPages() }
    }
    
    private func setupCollectionView() {
        collectionView.register(
            LaunchCell.self,
            forCellWithReuseIdentifier: LaunchCell.reusableID
        )
        
        let cellRegistration = UICollectionView.CellRegistration<
            LaunchCell,
            Launches.Output.Item
        >(handler: configure)
        
        dataSource = UICollectionViewDiffableDataSource<
            Launches.Output.Section,
            Launches.Output.Item
        >(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }

    private func configure(
        cell: LaunchCell,
        indexPath: IndexPath,
        item: Launches.Output.Item
    ) {
        cell.nameLabel.text = item.name
        cell.descriptionLabel.text = item.description
        cell.eventDateLabel.text = item.launchDate
    }
}

// SETUP View hierarchy
extension LaunchesViewController: ViewCodable {
    func setupHierarchyViews() {  }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
        ])
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
        navigationItem.title = "Launches"
        navigationItem.searchController = searchController
    }
}

extension NSDiffableDataSourceSnapshot<Launches.Output.Section, Launches.Output.Item> {
    init(viewModel: LaunchesViewModel) {
        self.init()
        appendSections([.main])
        appendItems(viewModel.launchesListItems)
    }
}

import SwiftUI
#Preview {
    UIViewControllerRepresenting {
        UINavigationController(
            rootViewController: LaunchesViewController(
                viewModel: .init(
                    searchQuery: "Falc",
                    launches: [
                        .mock(id: .init()),
                        .mock(id: .init()),
                        .mock(id: .init()),
                    ]
                )
            )
        )
    }
}
