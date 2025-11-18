//
//  ViewController.swift
//  itLinkTestTask
//
//  Created by Alexander Abanshin on 14.11.2025.
//

import UIKit

final class MainViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, URL>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, URL>

    private var dataSource: DataSource?
    private var collection: UICollectionView!

    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gallery"
        configureHierarchy()
        configureDataSource()
        bindViewModel()
        configureNavBar()
    }
    
    func bindViewModel() {
        viewModel.onDataLoaded = { [weak self] urls in
            self?.applySnapshot(with: urls)
        }
        viewModel.loadImages()
    }
}
private extension MainViewController {
    func configureHierarchy() {
        collection = UICollectionView(frame: view.bounds, collectionViewLayout: CollectionLayout.greedLayout())
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.showsVerticalScrollIndicator = false
        collection.delegate = self
        view.addSubview(collection)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ImageCell, URL> { cell, indexPath, item in
            cell.configure(url: item)
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collection,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell( using: cellRegistration, for: indexPath, item: itemIdentifier)
            })
    }

    func applySnapshot(with urls: [URL]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(urls)
        dataSource?.apply(snapshot)
    }
    
    func configureNavBar() {
        let button = UIBarButtonItem(
            image: UIImage(systemName: traitCollection.userInterfaceStyle == .dark ? "moon.fill" : "sun.max.fill"),
            style: .plain,
            target: self,
            action: #selector(toggleTheme)
        )
        navigationItem.rightBarButtonItem = button
    }

    @objc func toggleTheme() {
        if overrideUserInterfaceStyle == .dark {
            overrideUserInterfaceStyle = .light
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "sun.max.fill")
        } else {
            overrideUserInterfaceStyle = .dark
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "moon.fill")
        }
    }}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard  let urls = dataSource?.snapshot().itemIdentifiers  else { return }
        let viewer = ImageViewerPageViewController(urls: urls, startIndex: indexPath.item)
        let navigationController = UINavigationController(rootViewController: viewer)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}










































