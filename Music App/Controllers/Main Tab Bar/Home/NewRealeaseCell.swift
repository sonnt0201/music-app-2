//
//  NewRealeaseCell.swift
//  Music App
//
//  Created by Sơn Nguyễn on 18/07/2022.
//

import UIKit
import SDWebImage

//struct NewReleaseCellVM {
//    let name: String
//    let artworkURL: URL?
//    let numberOfTracks: Int
//    let artistName: String
//
//}

class NewRealeaseCell: UICollectionViewCell {
    static let identifier = "NewReleaseCell"
    
    private func addConstraints(){
        
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit() 
        numberOfTrackLabel.sizeToFit()
        let imageSize: CGFloat = contentView.bounds.height
        albumCoverImageView.clipsToBounds = true
        albumCoverImageView.layer.cornerRadius = 10
        
        albumCoverImageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        albumNameLabel.frame = CGRect(x: albumCoverImageView.bounds.width  + 10,
                                      y: 8,
                                      width: contentView.bounds.width - albumCoverImageView.bounds.width - 12,
                                      height: 24)
        
        artistNameLabel.frame = CGRect(x: albumCoverImageView.bounds.width + 15,
                                       y: contentView.bounds.height/2 - 10 ,
                                       width: contentView.bounds.width - albumCoverImageView.bounds.width - 12,
                                       height: 20)
        
        numberOfTrackLabel.frame = CGRect(x: albumCoverImageView.bounds.width  + 15,
                                          y: albumCoverImageView.bounds.height - 30,
                                          width: numberOfTrackLabel.bounds.width + 10,
                                          height: 20)
    }
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.note.house.fill")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    private let numberOfTrackLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
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
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTrackLabel)
        contentView.addSubview(artistNameLabel)
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
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTrackLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleaseCellVM){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTrackLabel.text = "Số track: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
