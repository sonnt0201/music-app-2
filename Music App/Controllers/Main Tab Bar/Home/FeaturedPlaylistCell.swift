//
//  FeaturedPlaylistCell.swift
//  Music App
//
//  Created by Sơn Nguyễn on 18/07/2022.
//

import UIKit

class FeaturedPlaylistCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCell"
    private func addConstraints(){
        albumCoverImageView.layer.cornerRadius = 4
        albumCoverImageView.clipsToBounds = true
        playlistNameLabel.sizeToFit()
        creatorNameLabel.sizeToFit()
        let imageSize: CGFloat = contentView.bounds.height*2/3
        albumCoverImageView.frame = CGRect(x: contentView.center.x - imageSize/2,
                                           y: 0,
                                           width: imageSize,
                                           height: imageSize)
        
        playlistNameLabel.frame = CGRect(x: 8,
                                         y: imageSize + 6 ,
                                         width: contentView.bounds.width - 10,
                                         height: 24)
        
        creatorNameLabel.frame = CGRect(x: 8,
                                       y: contentView.bounds.height - 22 ,
                                       width: contentView.bounds.width - 10,
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
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
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
        creatorNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: FeaturedPlaylistCellVM){
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
