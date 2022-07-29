//
//  SearchViewController.swift
//  Music App
//
//  Created by Sơn Nguyễn on 09/07/2022.
//

import UIKit
import SafariServices
class SearchViewController: UIViewController {

    let searchController: UISearchController = {
        
        let vc = UISearchController(searchResultsController: SearchResultsVC())
        vc.searchBar.placeholder = "Bài hát, nghệ sĩ, albums,... "
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 7,
                                                         bottom: 2,
                                                         trailing: 7)
            //group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(180)),
                subitem: item,
                count: 2)
            group.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                          leading: 0,
                                                          bottom: 10,
                                                          trailing: 0)
            //section
            let section = NSCollectionLayoutSection(group: group)
            return section
        })
    )
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(GenreCell.self,
                                forCellWithReuseIdentifier: GenreCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
}

// MARK: - SEARCH RESULTS UPDATING DELEGATE
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        guard let resultsController = searchController.searchResultsController as? SearchResultsVC,
//              let query = searchController.searchBar.text,
//              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
//            return
//        }
//        fetchData(query: query)
        //result controller.update(result)
        // MARK: - perform search
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let resultsController = searchController.searchResultsController as? SearchResultsVC,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        resultsController.delegate = self
        //resultsController.delegate = self
        fetchData(query: query, resultsController: resultsController)
    }
    
    func fetchData(query: String, resultsController: SearchResultsVC) {
        APICallers.shared.search(with: query) { results in
            DispatchQueue.main.async {
                switch results {
                case.success(let results):
                    resultsController.update(with: results)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

// MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: - Add genres
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GenreCell.identifier,
            for: indexPath) as? GenreCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: "")
        return cell
    }
    
    
    
}

extension SearchViewController: SearchResultsVCDelegate {
    func didTapResult(_ result: SearchResult) {
        switch result {
        case .artist(let model):
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc,animated: true)
        case .album(let model):
            let vc = AlbumViewController(album: model )
            navigationController?.pushViewController(vc, animated: true)
        case .track(let model):
            PlaybackPresenter.shared.startPlayback(from: self, tracks: [model])
        case .playlist(let model):
            let vc = PlaylistViewController(playlist: model)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
