//
//  WelcomeViewController.swift
//  Music App
//
//  Created by Sơn Nguyễn on 09/07/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    // MARK: - create sign in button
    private var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 24
        button.setTitle("Đăng nhập với Spotify", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    private var imageView: UIImageView = {
        let image = UIImage(named: "Image")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBackground
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MY MUSIC"
        view.backgroundColor = .systemBackground
        view.addSubview(signInButton)
        view.addSubview(imageView)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        addConstraints()
    }
     
    // MARK: - tap signIn Button
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleSignIn(success: Bool){
        // MARK: -  log in or noti for error
        guard success else {
            // MARK: - log in failure
            let alertVC = UIAlertController(title: "Đăng nhập thất bại",
                                            message: "Hãy kiểm tra mật khẩu, tên đăng nhập, kết nối, v.v.. và thử lại",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
            present(alertVC, animated: true)
            return
            
        }
        
        let mainTabBarVC = TabBarViewController()
        mainTabBarVC.modalPresentationStyle = .fullScreen
        present(mainTabBarVC, animated: true)
    }
    
    // MARK: - auto layout
    private func addConstraints(){

        signInButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.size.height * 4.5/12),
            signInButton.widthAnchor.constraint(equalToConstant: view.bounds.size.width * 5/6),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0),
            imageView.widthAnchor.constraint(equalToConstant: view.bounds.size.width * 5/6),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.size.width * 5/6)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}


