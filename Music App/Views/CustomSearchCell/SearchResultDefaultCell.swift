//
//  SearchResultDefaultCell.swift
//  Music App
//
//  Created by Sơn Nguyễn on 23/07/2022.
//

import UIKit
import SDWebImage



class SearchResultDefaultCell: UITableViewCell {
    static let identifier = "SearchResultDefaultCell"
    // MARK: - INIT SUBVIEWS
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    private let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private func addAutoLayout(){
        let imageSize = contentView.bounds.height - 3
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = imageSize/2
        iconImageView.frame = CGRect(x: 10,
                                     y: 0,
                                     width: imageSize,
                                     height: imageSize)
        label.frame = CGRect(x: iconImageView.frame.maxX + 10.0,
                             y: 0,
                             width: contentView.bounds.width - iconImageView.bounds.width - 6,
                             height: contentView.bounds.height)
    }
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        addAutoLayout()
    }
    
    func configure(with viewModel: SearchResultDefaultCellVM){
        self.label.text = viewModel.title
        self.iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}
