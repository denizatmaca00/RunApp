//
//  TabbarVC.swift
//  RunApp
//
//  Created by d-datmaca on 5.03.2024.
//

import UIKit
import SnapKit

class TabbarVC: UITabBarController {
    
    let homeVC = HomeVC()
    let mapVC = MapVC()
    let analyticsVC = AnalyticVC()
    let profileVC = ProfileVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = UIColor(named: "TabbarColor")
        self.tabBar.tintColor = UIColor(named: "ThemeColor")
        self.tabBar.layer.cornerRadius = 24
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.navigationItem.setHidesBackButton(true, animated: false)

                
        homeVC.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(systemName: "house.fill"), selectedImage: UIImage(named: "home_icon_selected"))
        mapVC.tabBarItem = UITabBarItem(title: "Harita", image: UIImage(systemName: "map.fill"), selectedImage: UIImage(named: "settings_icon_selected"))
        analyticsVC.tabBarItem = UITabBarItem(title: "Analiz", image: UIImage(systemName: "chart.bar.fill"), selectedImage: UIImage(named: "settings_icon_selected"))
        profileVC.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(named: "settings_icon_selected"))
        
        self.viewControllers = [homeVC, mapVC, analyticsVC, profileVC]
    }
}
