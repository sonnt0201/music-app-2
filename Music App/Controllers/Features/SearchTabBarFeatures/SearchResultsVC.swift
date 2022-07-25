//
//  SearchResultsVC.swift
//  Music App
//
//  Created by Sơn Nguyễn on 21/07/2022.
//

import Foundation
import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultsVCDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsVC: UIViewController {
    
    weak var delegate: SearchResultsVCDelegate?
    private var sections : [SearchSection] = []
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.register(SearchResultDefaultCell.self,
                           forCellReuseIdentifier: SearchResultDefaultCell.identifier)
        tableView.register(SearchResultSubtileCell.self,
                           forCellReuseIdentifier: SearchResultSubtileCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    // MARK: - AUTOLAYOUT
    func setAutoLayout(){
        tableView.frame = view.bounds
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setAutoLayout()
    }
    
    func update(with results: [SearchResult]) {
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        self.sections = [
            SearchSection(title: "Bài hát", results: tracks),
            SearchSection(title: "Nghệ sĩ", results: artists),
            SearchSection(title: "Albums", results: albums),
            SearchSection(title: "Playlists", results: playlists)
        ]
        tableView.isHidden = false
        
        tableView.reloadData()
    }
    
}

// MARK: - TABLEVIEW DELEGATE AND DATASOURCE

extension SearchResultsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
            
        case .artist(model: let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultCell.identifier, for: indexPath
            ) as? SearchResultDefaultCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultDefaultCellVM(
                title: artist.name,
                imageURL: URL(string: artist.images?.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
            
        case .album(model: let album):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtileCell.identifier, for: indexPath
            ) as? SearchResultSubtileCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtileCellVM(
                title: album.name,
                subtile: album.artists.first?.name ?? "-" ,
                imageURL: URL(string: album.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        case .track(model: let track):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtileCell.identifier, for: indexPath
            ) as? SearchResultSubtileCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtileCellVM(
                title: track.name,
                subtile: track.artists.first?.name ?? "-" ,
                imageURL: URL(string: track.album?.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        case .playlist(model: let playlist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtileCell.identifier, for: indexPath
            ) as? SearchResultSubtileCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultSubtileCellVM(
                title: playlist.name,
                subtile: playlist.owner.display_name ?? "-" ,
                imageURL: URL(string: playlist.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
}
