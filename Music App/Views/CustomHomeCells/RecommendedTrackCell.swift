//
//  RecommendedTrackCell.swift
//  Music App
//
//  Created by Sơn Nguyễn on 18/07/2022.
//

import UIKit

class RecommendedTrackCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCell"
    private func addConstraints(){
        playlistNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        let imageSize: CGFloat = contentView.bounds.height
        albumCoverImageView.layer.cornerRadius = 10
        albumCoverImageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        playlistNameLabel.frame = CGRect(x: albumCoverImageView.bounds.width  + 10,
                                         y: 10,
                                      width: contentView.bounds.width - albumCoverImageView.bounds.width - 12,
                                      height: 24)
        
        artistNameLabel.frame = CGRect(x: albumCoverImageView.bounds.width + 15,
                                       y: contentView.bounds.height/2 + 5 ,
                                       width: contentView.bounds.width - albumCoverImageView.bounds.width - 12,
                                       height: 20)
        
        
    }
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.note.house.fill")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.addConstraints()
        }
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: RecommendedTrackCellVM){ 
        playlistNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
            
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
