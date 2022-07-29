//
//  SettingViewController.swift
//  Music App
//
//  Created by Sơn Nguyễn on 09/07/2022.
//

import UIKit

class SettingViewController: UIViewController {
    // MARK: - init table view
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        configSettings()
        title = "Chỉnh Sửa"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - config settings
    private var sections = [Section]()
    private func configSettings() {
        sections.append(Section(title: "Cá nhân", options: [Option(title: "Thông tin tài khoản", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
            
        })]))
        
        sections.append(Section(title: "Tài khoản", options: [Option(title: "Đăng xuất", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOut()
            }
            
        })]))
    }
    
}

// MARK: - delegate and datasource
extension SettingViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    
}

extension SettingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler( )
    }
}

// MARK: - setting config list
extension SettingViewController {
    private func viewProfile(){
        let vc = ProfileViewController()
        vc.title = "Cá Nhân"
        navigationController?.pushViewController(vc, animated: true)
    }
    private func signOut(){
        // TODO: - signout
        AuthManager.shared.signOut { [weak self] _ in
            DispatchQueue.main.async {
                let signInVC = UINavigationController(rootViewController: WelcomeViewController())
                signInVC.modalPresentationStyle = .fullScreen
                self?.present(signInVC, animated: true)
            }
        }
    }
}
