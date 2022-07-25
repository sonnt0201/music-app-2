//
//  PlayerViewController.swift
//  Music App
//
//  Created by Sơn Nguyễn on 23/07/2022.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider( _ value: Float)
}
class PlayerViewController: UIViewController {
     
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBackground
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    private let controlsView = PlayerControlsView()
    
    private func setAutoLayout(){
        let imageSize = view.bounds.width*5/6
        imageView.frame = CGRect(x: (view.bounds.width - imageSize)/2,
                                 y: (view.bounds.width - imageSize)/2 + 20,
                                 width: imageSize,
                                 height: imageSize)
        controlsView.frame = CGRect(x: imageView.frame.minX,
                                    y: imageView.frame.maxY + 20,
                                    width: imageSize,
                                    height: view.bounds.height - imageSize - 40)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        configBarButtons()
        controlsView.delegate = self
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setAutoLayout()
    }
    
    private func configBarButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                           target: self,
                                                           action: #selector(didTapAction))
    }
    private func configure(){
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        controlsView.configure(with: PlayerControlsVM(title: dataSource?.songName,
                                                      subtile: dataSource?.subtitle))
    }
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    @objc private func didTapAction(){
        // TODO: - Action
    }
    func refreshUI() {
        configure()
    }
}

extension PlayerViewController: PlayerControlsViewDelegate {
    
    
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
        }

}
