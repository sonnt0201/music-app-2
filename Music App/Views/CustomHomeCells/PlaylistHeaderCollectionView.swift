//
//  PlaylistHeaderCollectionView.swift
//  Music App
//
//  Created by Sơn Nguyễn on 21/07/2022.
//

import UIKit
import SDWebImage
protocol PlaylistHeaderCollectionViewDelegate: AnyObject {
    func playlistHeaderViewDidTapPlayAll (_ header: PlaylistHeaderCollectionView)
}

class PlaylistHeaderCollectionView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionView"
    weak var delegate: PlaylistHeaderCollectionViewDelegate?
    // MARK: - OUTLET
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .light)
        // MARK: - set tự xuống dòng
        //label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setImage( UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - AUTO LAYOUT BY CODE
    private func setAutoLayout(){
        let imageSize: CGFloat = self.bounds.height/1.8
        imageView.frame = CGRect(x: (self.bounds.width - imageSize)/2,
                                 y: 20,
                                 width: imageSize,
                                 height: imageSize)
        
        nameLabel.frame = CGRect(x: 10 ,
                                 y: imageView.frame.maxY + 5.0,
                                 width: self.bounds.width - 10,
                                 height: 22)
        descriptionLabel.frame = CGRect(x: 10,
                                        y: nameLabel.frame.maxY,
                                        width: self.bounds.width - 10,
                                        height: 50)
        ownerLabel.frame = CGRect(x: 10,
                                  y: descriptionLabel.frame.maxY + 10,
                                  width: self.bounds.width - 10,
                                  height: 20)
        playAllButton.frame = CGRect(x: self.bounds.width - 70,
                                     y: self.bounds.height - 100,
                                     width: 50,
                                     height: 50)
        playAllButton.layer.cornerRadius = playAllButton.bounds.width/2
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(nameLabel)
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        setAutoLayout()
    }
    
    @objc private func didTapPlayAll(){
        // TODO: - PLAY ALL LIST
        delegate?.playlistHeaderViewDidTapPlayAll(self)
    }
    
    func configure(with viewModel: PlaylistHeaderCollectionViewVM) {
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        imageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
    }
}
