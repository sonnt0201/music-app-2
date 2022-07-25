//
//  TitleHeaderCollectionView.swift
//  Music App
//
//  Created by Sơn Nguyễn on 21/07/2022.
//
// MARK: - THIS VIEW IS HEADER OF HomeViewController COLLECTION VIEW
import UIKit

class TitleHeaderCollectionView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionView"
    private let label : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private func setAutoLayout(){
        label.frame = CGRect(x: 10,
                             y: 0,
                             width: self.bounds.width - 20,
                             height: self.bounds.height)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setAutoLayout()
    }
    func configure(with title: String){
        label.text = title
    }
}
