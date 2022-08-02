//
//  TabBarViewController.swift
//  Music App
//
//  Created by Sơn Nguyễn on 09/07/2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - set back ground color for tabbar
        tabBarItem.badgeColor = .systemBackground
        
        // MARK: - create tabbar vc
        let vc1 = HomeViewController()
        let vc2 = SearchViewController()
//        let vc3 = LibraryViewController()
        
        // MARK: - set titles
        vc1.title = "ÂM NHẠC"
        vc2.title = "TÌM KIẾM"
//        vc3.title = "THƯ VIỆN"
        
        
       // MARK: - set large title
        vc1.navigationItem.largeTitleDisplayMode = .automatic
        vc2.navigationItem.largeTitleDisplayMode = .automatic
//        vc3.navigationItem.largeTitleDisplayMode = .automatic
        
        // MARK: - set root vc
        let nv1 = UINavigationController(rootViewController: vc1)
        let nv2 = UINavigationController(rootViewController: vc2)
//        let nv3 = UINavigationController(rootViewController: vc3)
        
        nv1.navigationBar.prefersLargeTitles = true
        nv2.navigationBar.prefersLargeTitles = true
//        nv3.navigationBar.prefersLargeTitles = true
        // MARK: - set image for tabbar
        nv1.tabBarItem = UITabBarItem(title: "TRANG CHỦ", image: UIImage(systemName: "house") , tag: 1)
        nv2.tabBarItem = UITabBarItem(title: "TÌM KIẾM", image: UIImage(systemName: "magnifyingglass") , tag: 2)
//        nv3.tabBarItem = UITabBarItem(title: "THƯ VIỆN", image: UIImage(systemName: "book") , tag: 3)
       
        // MARK: - add nv to tab bar
        nv1.navigationBar.tintColor = .systemOrange
        // TODO: - THIẾU NV 3. CHƯA LÀM
        setViewControllers([nv1, nv2], animated: false)
        UITabBar.appearance().backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .red
        
    }
    

}
