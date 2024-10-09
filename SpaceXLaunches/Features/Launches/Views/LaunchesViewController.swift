//
//  LaunchesViewController.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 06.10.2024.
//

import UIKit
import UIKitNavigation
import Kingfisher

class LaunchesViewController: UICollectionViewController {
    
    @UIBindable var viewModel: LaunchesViewModel
    
    private var fetchListTask: Task<Void, Never>?
    
    var dataSource: UICollectionViewDiffableDataSource<Launches.Output.Section, Launches.Output.Item>!
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.isHidden = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Past Launches"
        searchController.searchBar.searchTextField.bind(text: $viewModel.searchQuery)
        definesPresentationContext = true
        return searchController
    }()
    
    lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.font = .systemFont(ofSize: 16, weight: .bold)
        errorLabel.textColor = .red
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        return errorLabel
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
            handleRequestState(viewModel.requestState)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchListTask?.cancel()
        let task = Task {
            await viewModel.fetchPastLaunchesAllPages()
            fetchListTask = .none
        }
        fetchListTask = task
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
        cell.iconView.kf.setImage(with: item.imageUrl)
    }
    
    func handleRequestState(_ state: LaunchesViewModel.RequestState?) {
        switch viewModel.requestState {
        case .inFlight:
            loadingView.startAnimating()
            loadingView.isHidden = false
            
        case .error(let description):
            errorLabel.text = description
            errorLabel.isHidden = false
            
        case .none:
            errorLabel.isHidden = true
            loadingView.isHidden = true
        }
    }
}

// SETUP View hierarchy
extension LaunchesViewController: ViewCodable {
    func setupHierarchyViews() { 
        self.collectionView.addSubview(errorLabel)
        self.collectionView.addSubview(loadingView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            errorLabel.trailingAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.trailingAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.leadingAnchor),
            errorLabel.topAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.topAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.centerXAnchor),
            loadingView.topAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.topAnchor),
        ])
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
        collectionView.layoutMargins = .init(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
        navigationItem.title = "Launches"
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension NSDiffableDataSourceSnapshot<Launches.Output.Section, Launches.Output.Item> {
    init(viewModel: LaunchesViewModel) {
        self.init()
        appendSections([.main])
        appendItems(viewModel.launchesListItems)
    }
}

import Dependencies
import SwiftUI
#Preview {
    UIViewControllerRepresenting {
        UINavigationController(
            rootViewController: LaunchesViewController(
                viewModel: .init(
                    searchQuery: "Falc",
                    launches: (0...10).map { _ in
                        Launch.mock(
                            id: UUID.init().uuidString,
                            imageUrl: URL(string: "http://www.test.com")
                        )
                    }
                )
            )
        )
    }
    .mockCachedImages(
        image: UIImage(named: "launch-icon-test")!,
        cacheKey: "http://www.test.com"
    )
}

#Preview("Error") {
    UIViewControllerRepresenting {
        UINavigationController(
            rootViewController: LaunchesViewController(
                viewModel: withDependencies {
                    $0.apiClient.fetchPastLaunches = { _ in
                        throw NSError(domain: "Test", code: 500)
                    }
                } operation: {
                    .init()
                }
            )
        )
    }
}
