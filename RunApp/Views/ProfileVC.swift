//
//  ProfileVC.swift
//  RunApp
//
//  Created by d-datmaca on 6.03.2024.
// TODO: presnet düzenle butonu
// TODO: premiumda kendi gelişimini takip debileceiğin alanlar açılabilir.
//import UIKit
//
//class ProfileVC: UIViewController {
//    
//    private var collectionView: UICollectionView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            
//            let firstItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
//            let firstItem = NSCollectionLayoutItem(layoutSize: firstItemSize)
//            firstItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//            
//            // Diğer hücreler için boyut tanımlama
//            let otherItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
//            let otherItem = NSCollectionLayoutItem(layoutSize: otherItemSize)
//            
//            // İlk hücreyi içeren grup oluşturma
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(400))
//            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [firstItem, otherItem])
//            
//            let section = NSCollectionLayoutSection(group: group)
//            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//            return section
//        }
//        
//        // Collection View oluşturma
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = UIColor(named: "preLoginColor")
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(ProfileInfoCollectionViewCell.self, forCellWithReuseIdentifier: "firstCell")
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        view.addSubview(collectionView)
//    }
//}
//
//extension ProfileVC: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath) as! ProfileInfoCollectionViewCell
//            cell.getProfileInfosFromFB()
//            return cell
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//            cell.backgroundColor = .lightGray
//            return cell
//        }
//    }
//
//}
//
//extension ProfileVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // Collection view öğelerinden birine tıklama işlemi
//    }
//}

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "preLoginColor")
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .clear // Arka plan rengini temizle
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    func logout() {
            do {
                try Auth.auth().signOut()
                // Çıkış işlemi başarılı oldu, giriş ekranına yönlendir
                let preLoginVC = PreLoginVC()
                let navigationController = UINavigationController(rootViewController: preLoginVC)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true, completion: nil)
            } catch {
                print("Çıkış işlemi başarısız: \(error.localizedDescription)")
            }
        }
}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // Toplam öğe sayısı
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = UIColor(named: "ThemeColor") // Başlık rengini tema rengi olarak ayarla
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Profil Bilgilerim"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        case 1:
            cell.textLabel?.text = "Ayarlar"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        case 2:
            cell.textLabel?.text = "Tema Değiştir"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        case 3:
            cell.textLabel?.text = "Çıkış"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let profileInfoVC = ProfileInfoVC()
            let navigationController = UINavigationController(rootViewController: profileInfoVC)
            self.present(navigationController, animated: true, completion: nil)
        case 1:
            AppAlert.showAlert(title: "Çok Yakında", message: nil, type: .info, viewController: self)
            break
        case 2:
            AppAlert.showAlert(title: "Çok Yakında", message: nil, type: .info, viewController: self)
            break
        case 3:
            logout()
            break
        default:
            break
        }
    }
}
