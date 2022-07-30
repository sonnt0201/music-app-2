//
//  ViewController.swift
//  Music App
//
//  Created by Sơn Nguyễn on 09/07/2022.
//

import UIKit

enum HomeSectionType {
    case newReleases(viewModels: [NewReleaseCellVM]) // 1
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellVM]) // 2
    case recommendedTracks(viewModels: [RecommendedTrackCellVM]) // 3
    var title: String {
        switch self {
        case.newReleases:
            return "Album Mới Phát Hành"
        case.featuredPlaylists:
            return "Album Thịnh Hành"
        case.recommendedTracks:
            return "Được Đề Xuất"
        }
    }
}

class HomeViewController: UIViewController {

    
    private var collectionView : UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private var sections = [HomeSectionType]()
    private var newAlbums : [Album] = []
    private var playlists : [Playlist] = []
    private var tracks : [AudioTrack] = []
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        configCollectionView()
        fetchData()
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // MARK: - add profile button to navigation right bar item
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSetting)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc func didTapSetting(){
        let vc = SettingViewController()
        vc.title = "Chỉnh sửa"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeViewController {
    private func fetchData(){
        let group = DispatchGroup()
        // MARK: - FEATURED PLAYLISTS, RECOMMENDED TRACKS, NEW RELEASES
        group.enter()
        group.enter()
        group.enter()
        print("start fetching data")
        var newReleases: NewReleasesResponse?
        var featuredPlaylists: FeaturedPlaylistsResponse?
        var recommendations : RecommendationResponse?
        
        APICallers.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case.success(let model):
                newReleases = model
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICallers.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            switch result{
            case.success(let model):
                featuredPlaylists = model
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICallers.shared.getRecommendedGenres { result in
            
            switch result {
            case.success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                // MARK: - random some genres to recommend
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                APICallers.shared.getRecommendations(genres: seeds) { recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult {
                    case.success(let model):
                        recommendations = model
                    case.failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylists?.playlists.items,
                  let tracks = recommendations?.tracks else {
                fatalError("models are nil")
            }
            print("configuring view  models")
            self.configureModels(
                newAlbums: newAlbums,
                playlists: playlists,
                tracks: tracks
            )
        }
        
    }
    
    private func configureModels(
        newAlbums: [Album],
        playlists: [Playlist] ,
        tracks: [AudioTrack]
    ){
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleaseCellVM(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? "-"
            )
        })))
        
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            return FeaturedPlaylistCellVM(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.display_name
            )
        })))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return RecommendedTrackCellVM(
                name: $0.name,
                artworkURL: URL(string: $0.album?.images.first?.url ?? ""),
                artistName: $0.artists.first?.name ?? ""
            )
        })))
        collectionView.reloadData()
    }
}

// MARK: - SETTINGS FOR COLLECTION VIEW
extension HomeViewController {
        // MARK: - CONFIG COLLECTION VIEW
    private func configCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(NewRealeaseCell.self, forCellWithReuseIdentifier: NewRealeaseCell.identifier)
        collectionView.register(FeaturedPlaylistCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCell.identifier)
        collectionView.register(RecommendedTrackCell.self, forCellWithReuseIdentifier: RecommendedTrackCell.identifier)
        collectionView.register(TitleHeaderCollectionView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleHeaderCollectionView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    // MARK: - CREATE SECTION LAYOUT
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        switch section {
        // MARK: - LAYOUT FOR NEW RELEASES CELL
        case 0 :
            // MARK: - item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0.75, leading: 0.75, bottom: 0.75, trailing: 0.75)
            // MARK: - group: vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(390)),
                subitem: item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
                                                   heightDimension: .absolute(400)),
                subitem: verticalGroup,
                count: 1)
            // MARK: - section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        // MARK: - LAYOUT FOR FEATURED PLAYLIST CELL
        case 1:
            // MARK: - item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0.75, leading: 0.75, bottom: 0.75, trailing: 0.75)
            // MARK: - group: vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(480)),
                subitem: item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
                                                   heightDimension: .absolute(500)),
                subitem: verticalGroup,
                count: 2)
            // MARK: - section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        // MARK: - LAYOUT FOR RECOMMENDED TRACK CELL
        case 2:
            // MARK: - item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0.75, leading: 0.75, bottom: 0.75, trailing: 0.75)
            // MARK: - group: vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(270)),
                subitem: item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
                                                   heightDimension: .absolute(270)),
                subitem: verticalGroup,
                count: 1)
            // MARK: - section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            // MARK: - item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0.75, leading: 0.75, bottom: 0.75, trailing: 0.75)
            // MARK: - group: vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(390)),
                subitem: item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
                                                   heightDimension: .absolute(390)),
                subitem: verticalGroup,
                count: 1)
            // MARK: - section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
}

// MARK: - DELEGATE AND DATASOURCE FOR COLLECTION VIEW
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case.newReleases(viewModels: let viewModels):
            return viewModels.count
        case.featuredPlaylists(viewModels: let viewModels):
            return viewModels.count
        case.recommendedTracks(viewModels: let viewModels):
            return viewModels.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        // MARK: - NEW RELEASEES VM CELL
        case.newReleases(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewRealeaseCell.identifier,
                for: indexPath) as? NewRealeaseCell else { return UICollectionViewCell() }
            cell.backgroundColor = .systemGreen
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        // MARK: - FEATURED PLAYLISTS
        case.featuredPlaylists(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCell.identifier,
                for: indexPath) as? FeaturedPlaylistCell else { return UICollectionViewCell() }
            cell.backgroundColor = .systemBlue
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        // MARK: - RECOMMENDED TRACK
        case.recommendedTracks(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTrackCell.identifier,
                for: indexPath) as? RecommendedTrackCell else { return UICollectionViewCell() }
            cell.backgroundColor = .systemRed
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case.newReleases:
            let album = newAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.setToolbarHidden(false, animated: true)
        case.featuredPlaylists:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.setToolbarHidden(false, animated: true)
        case.recommendedTracks:
            let track = tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, tracks: [track] )
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionView.identifier,
            for: indexPath
        ) as? TitleHeaderCollectionView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
}


 //MARK: - HIDE TITLE WHEN SCROLL
extension HomeViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            UIView.animate(withDuration: 1/velocity.y, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.setToolbarHidden(true, animated: true)
                print("Hide")
                self.navigationController?.navigationBar.prefersLargeTitles = false
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 1/velocity.y, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.setToolbarHidden(false, animated: true)
                print("Unhide")
                self.navigationController?.navigationBar.prefersLargeTitles = true
            }, completion: nil)
            
        }
    }
}
