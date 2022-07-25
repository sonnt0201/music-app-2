//
//  RecommendedTrackCell.swift
//  Music App
//
//  Created by Sơn Nguyễn on 18/07/2022.
//

import UIKit

class AlbumTrackCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCell"
    private func addConstraints(){
        playlistNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        let imageSize: CGFloat = contentView.bounds.height
        
        playlistNameLabel.frame = CGRect(x: 10,
                                         y: 10,
                                      width: contentView.bounds.width  - 12,
                                      height: 24)
        
        artistNameLabel.frame = CGRect(x: 10,
                                       y: contentView.bounds.height/2 + 5 ,
                                       width: contentView.bounds.width - 12,
                                       height: 20)
        
        
    }
    
    
    
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
    }
    
    func configure(with viewModel: AlbumTrackCellVM){
        playlistNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    
            
      
    }
}
