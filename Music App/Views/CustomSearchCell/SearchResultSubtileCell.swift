//
//  SearchResultSubtileCell.swift
//  Music App
//
//  Created by Sơn Nguyễn on 23/07/2022.
//


import UIKit
import SDWebImage



class SearchResultSubtileCell: UITableViewCell {
    static let identifier = "SearchResultSubtileCell"
    // MARK: - INIT SUBVIEWS
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subtileLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        
        return label
    }()
    private let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private func addAutoLayout(){
        let imageSize = contentView.bounds.height - 3
        let labelHeight = contentView.bounds.height/2
        iconImageView.frame = CGRect(x: 10,
                                     y: 0,
                                     width: imageSize,
                                     height: imageSize)
        label.frame = CGRect(x: iconImageView.frame.maxX + 10.0,
                             y: 0,
                             width: contentView.bounds.width - iconImageView.bounds.width - 6,
                             height: labelHeight)
        subtileLabel.frame = CGRect(x: iconImageView.frame.maxX + 10.0,
                             y: labelHeight,
                             width: contentView.bounds.width - iconImageView.bounds.width - 6,
                             height: labelHeight)
    }
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(subtileLabel)
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
        subtileLabel.text = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        addAutoLayout()
    }
    
    func configure(with viewModel: SearchResultSubtileCellVM){
        self.label.text = viewModel.title
        self.subtileLabel.text = viewModel.subtile
        self.iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}
