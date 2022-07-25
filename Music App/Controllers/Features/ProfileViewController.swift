//
//  ProfileViewController.swift
//  Music App
//
//  Created by Sơn Nguyễn on 09/07/2022.
//

import SDWebImage
import UIKit

class ProfileViewController: UIViewController {
    private var models = [String]()
    // MARK: - init table View
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        title = "Cá nhân"
        view.backgroundColor = .systemBackground
        fetchProfile()
    }
    
    // MARK: - fetch profile data
    func fetchProfile(){
        APICallers.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure(let error):
                    print("Profile Error \(error.localizedDescription)")
                    self?.failedToGetProfile()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private func updateUI(with model: UserProfile){
        tableView.isHidden = false
        // MARK: - config table model
        models.append("Tên người dùng: \(model.display_name)")
        models.append("User ID: \(model.id)")
        models.append("Product: \(model.product)")
        models.append("Quốc gia: \(model.country)")
        // MARK: - avt image
        createTableHeader(with: model.images.first?.url)
        tableView.reloadData()
    }
    
    // MARK: - avatar as table header
    private func createTableHeader(with string : String?) {
        guard let urlString = string, let url = URL(string: urlString) else { return }
        let headerView : UIView = {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/1.5))
            let imageSize : CGFloat = headerView.bounds.height/2
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
            headerView.addSubview(imageView)
            imageView.center = headerView.center
            imageView.contentMode = .scaleAspectFit
            imageView.sd_setImage(with: url, completed: nil)
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = imageSize/2
            // MARK: - set shadow for avt
            
            return headerView
        }()
        
        tableView.tableHeaderView = headerView
    }
    private func failedToGetProfile(){
        let label = UILabel(frame: .zero)
        label.text = "Không có dữ liệu"
        label.sizeToFit()
        label.textColor = .systemRed
        label.font = UIFont(name: "Bold", size: 18)
        view.addSubview(label)
        label.center = view.center
        
    }

}

// MARK: - ui table view data source and delegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

