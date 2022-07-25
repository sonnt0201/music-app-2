//
//  GenreCell.swift
//  Music App
//
//  Created by Sơn Nguyễn on 22/07/2022.
//

import UIKit

class GenreCell: UICollectionViewCell {
    static let identifier = "GenreCell"
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(
                                    pointSize: 50,
                                    weight: .regular
                                  ))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    private let label : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        //label.numberOfLines = 0
        return label
    }()
    private let colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemPurple,
        .systemOrange,
        .systemGreen,
        .systemRed,
        .systemYellow,
        .darkGray,
        .systemTeal
    ]
    // MARK: - SET AUTOLAYOUT
    private func setAutoLayout(){
        label.sizeToFit()
        imageView.frame = CGRect(x: 0,
                                 y: contentView.bounds.width/2,
                                 width: contentView.bounds.width,
                                 height: contentView.bounds.height )
        label.frame = CGRect(x: 10,
                             y: 10,
                             width: contentView.bounds.width/2,
                             height: 26)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemOrange
        layer.cornerRadius = 6
        layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
         fatalError()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        // FIXME: - ADD IMAGE FOR imageView
        imageView.image = UIImage(systemName: "",
                                  withConfiguration: UIImage.SymbolConfiguration(
                                    pointSize: 50,
                                    weight: .regular
                                  ))
         
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setAutoLayout()
    }
    func configure(with title: String){
        label.text = title
        contentView.backgroundColor = colors.randomElement()
    }
}
