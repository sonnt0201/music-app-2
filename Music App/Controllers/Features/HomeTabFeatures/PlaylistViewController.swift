//
//  PlaylistViewController.swift
//  Music App
//
//  Created by Sơn Nguyễn on 20/07/2022.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let playlist: Playlist
    private var tracks = [AudioTrack]()
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0.75, leading: 1, bottom: 0.75, trailing: 1)
            // MARK: - group: vertical group in horizontal group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(80)),
                subitem: item,
                count: 1)
            // MARK: - section
            let section = NSCollectionLayoutSection(group: group)
            // MARK: - add header and footer
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalHeight(0.5)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
            ]
            return section
        })
    )
    
    private var viewModels = [RecommendedTrackCellVM]()
    init(playlist: Playlist){
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        // MARK: - collection view register
        collectionView.register(RecommendedTrackCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCell.identifier)
        collectionView.register(PlaylistHeaderCollectionView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionView.identifier)
        
        // MARK: - FETCH DATA
       
        APICallers.shared.getPlaylistDetails(for: playlist) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(let model):
                    self?.tracks = model.tracks.items.compactMap({
                        $0.track
                    })
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendedTrackCellVM(name: $0.track.name,
                                               artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""),
                                               artistName: $0.track.artists.first?.name ?? "-"
                        )
                    })
                    self?.collectionView.reloadData()
                case.failure(let error):
                    break
                }
            }
            
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))
    }
    @objc private func didTapShare() {
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {
            return
        }
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
}

// MARK: - COLLECTION VIEW DELEGATE AND DATASOURCE
extension PlaylistViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedTrackCell.identifier,
            for: indexPath) as? RecommendedTrackCell else {
                return UICollectionViewCell()
            }
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 5
        cell.configure(with: viewModels[indexPath.row])
        cell.backgroundColor = .red
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // TODO: - PLAY SONG
        let index = indexPath.row
        let track = tracks[index]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionView.identifier,
            for: indexPath
        ) as? PlaylistHeaderCollectionView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderCollectionViewVM (
            name: playlist.name,
            ownerName: playlist.owner.display_name,
            description: playlist.description,
            artWorkURL: URL(string: playlist.images.first?.url ?? ""))
         header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
}

extension PlaylistViewController: PlaylistHeaderCollectionViewDelegate {
    func playlistHeaderViewDidTapPlayAll(_ header: PlaylistHeaderCollectionView) {
        // TODO: - START PLAYLIST PLAYING IN QUEUE
        PlaybackPresenter.shared.startPlayback(
            from: self,
            tracks: tracks)
        print("play all")
    }
}
