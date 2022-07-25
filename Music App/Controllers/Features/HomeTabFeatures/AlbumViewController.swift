//
//  AlbumViewController.swift
//  Music App
//
//  Created by Sơn Nguyễn on 20/07/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
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
    
    private var viewModels = [AlbumTrackCellVM]()
    private let album: Album
    private var tracks = [AudioTrack]()
    init(album: Album){
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        // MARK: - collection view register
        collectionView.register(AlbumTrackCell.self,
                                forCellWithReuseIdentifier: AlbumTrackCell.identifier)
        collectionView.register(PlaylistHeaderCollectionView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionView.identifier)
        APICallers.shared.getAlbumDetails(for: self.album) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        AlbumTrackCellVM(name: $0.name,
                                         artistName: $0.artists.first?.name ?? "-"
                        )
                    })
                    self?.collectionView.reloadData()
                    
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}
    
extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumTrackCell.identifier,
            for: indexPath) as? AlbumTrackCell else {
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
        var track = tracks[indexPath.row]
        track.album = self.album
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
            name: album.name,
            ownerName: album.artists.first?.name,
            description: "Ngày phát hành: \(album.release_date)",
            artWorkURL: URL(string: album.images.first?.url ?? ""))
         header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
}

extension AlbumViewController: PlaylistHeaderCollectionViewDelegate {
    func playlistHeaderViewDidTapPlayAll(_ header: PlaylistHeaderCollectionView) {
        // TODO: - START PLAYLIST PLAYING IN QUEUE
        print("play all")
        let tracksWithAlbum: [AudioTrack] = tracks.compactMap {
            var track = $0
            track.album? = self.album
            return track
        }
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }
}
    
    
    
    
    
    
    
