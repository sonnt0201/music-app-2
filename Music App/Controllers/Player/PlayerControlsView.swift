//
//  PlayerControlsView.swift
//  Music App
//
//  Created by Sơn Nguyễn on 23/07/2022.
//

// MARK: - ĐÂY LÀ SUBVIEW CỦA PlayerViewController

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
    
}
struct PlayerControlsVM {
    let title: String?
    let subtile: String?
}
final class PlayerControlsView: UIView {
    private var isPlaying = true
    weak var delegate: PlayerControlsViewDelegate?
    // MARK: - SUBVIEWS (6)
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        
        return slider
    }()
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.backgroundColor = .label
        label.text = "Nghe Nhạc Anh Mỗi Khi Buồn"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    private let subtitleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Kiên"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.backgroundColor = .label
        label.textColor = .secondaryLabel
        return label
    }()
    private let backButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,
                                                                           weight: .regular
                                                                          ))
        button.setImage(image, for: .normal)
        return button
    }()
    private let nextButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,
                                                                           weight: .regular
                                                                          ))
        button.setImage(image, for: .normal)
        return button
    }()
    private let playPauseButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,
                                                                           weight: .regular
                                                                          ))
        button.setImage(image, for: .normal)
        return button
    }()
    // MARK: - SET AUTO LAYOUT
    private func setAutoLayout(){
    
        nameLabel.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.bounds.width,
                                 height: 50)
        nameLabel.backgroundColor = .systemBackground
        
        subtitleLabel.frame = CGRect(x: 0,
                                     y: nameLabel.frame.maxY + 10,
                                     width: self.bounds.width,
                                     height: 30)
        subtitleLabel.backgroundColor = .systemBackground
        volumeSlider.frame = CGRect(x: 0,
                                    y: subtitleLabel.frame.maxY + 12.0,
                                    width: self.bounds.width,
                                    height: 16)
        let buttonSize : CGFloat = 60
        playPauseButton.frame = CGRect(x: (self.bounds.width - buttonSize)/2,
                                       y: volumeSlider.frame.maxY + 14.0,
                                       width: buttonSize,
                                       height: buttonSize)
        
        backButton.frame = CGRect(x: self.bounds.width/3 - buttonSize - 10,
                                  y: playPauseButton.frame.minY,
                                  width: buttonSize,
                                  height: buttonSize)
        nextButton.frame = CGRect(x: self.bounds.width*2/3 + 10,
                                  y: playPauseButton.frame.minY,
                                  width: buttonSize,
                                  height: buttonSize)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(volumeSlider)
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(nextButton)
        addSubview(backButton)
        addSubview(playPauseButton)
        clipsToBounds = true
        
        // MARK: - ADD TARGETS
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAutoLayout()
    }
    
    // MARK: - @objc METHODS
    @objc private func didTapBack() {
        delegate?.playerControlsViewDidTapBackwardButton(self)
    }
    @objc private func didTapNext() {
        delegate?.playerControlsViewDidTapForwardButton(self)
    }
    @objc private func didTapPlayPause() {
        self.isPlaying = !self.isPlaying
        delegate?.playerControlsViewDidTapPlayPause(self)
        // MARK: -  update image
        let pause = UIImage(systemName: "pause",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,
                                                                           weight: .regular
                                                                          ))
        let play = UIImage(systemName: "play.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,
                                                                           weight: .regular
                                                                          ))
        
        playPauseButton.setImage(self.isPlaying ? pause:play, for: .normal)
    }
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    // MARK: - CONFIG
    func configure(with viewModel: PlayerControlsVM){
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtile
    }
}
