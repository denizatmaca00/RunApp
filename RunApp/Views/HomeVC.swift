//
//  HomeVC.swift
//  RunApp
//
//  Created by d-datmaca on 5.03.2024.
// TODO: üye ol sayfasında şifrelerde strongpassword çıkıyor
// TODO: profil bilgilerinde şifreyi tutmamışsın şifre değiştirme ekranında işe yarayacak ya da datayı unutursan :/
// TODO: oturumdan çık butonu
// TODO:

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeVC: UIViewController {
    
    var username = ""
    var runsAim: [[String: Any]] = []
    var runsDone: [[String: Any]] = []

    private lazy var labelHomeSecond: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Arial Bold", size: 18)
        return lbl
    }()
    
    private lazy var labelHomeThird: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "TabbarColor")
        lbl.font = UIFont(name: "Arial Bold", size: 18)
        return lbl
    }()
    
    private lazy var collectionViewHorizontalTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Nerede koşabilirsin?"
        lbl.textColor = UIColor(named: "TabbarColor")
        lbl.font = UIFont(name: "Arial Bold", size: 18)
        return lbl
    }()
    
    private lazy var collectionViewHorizontal: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewHorizontalCell.self, forCellWithReuseIdentifier: "HorizontalCell")
        collectionView.backgroundColor = UIColor(named: "preLoginColor")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var collectionViewVerticaltitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Önceki Koşularına Göz At"
        lbl.textColor = UIColor(named: "TabbarColor")
        lbl.font = UIFont(name: "Arial Bold", size: 18)
        return lbl
    }()
    
    private lazy var collectionViewVertical: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewVerticalCell.self, forCellWithReuseIdentifier: "VerticalCell")
        collectionView.backgroundColor = UIColor(named: "preLoginColor")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "preLoginColor")
        setupViews()
        navigationController?.navigationBar.isHidden = true
        
        let profileCell = ProfileInfoCollectionViewCell()
        profileCell.delegate = self
        
        profileCell.getProfileInfosFromFB()
        
        if let currentUser = Auth.auth().currentUser {
            getRunsAimFromFirestore(forUser: currentUser)
            getRunsFromFirestore(forUser: currentUser)
        }
    }

    private func getRunsAimFromFirestore(forUser user: User) {
        let firestoreDB = Firestore.firestore()

        guard let currentUserEmail = user.email else {
            print("Kullanıcının e-posta adresi yok.")
            return
        }

        firestoreDB.collection("users").document(currentUserEmail).collection("goalToday").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Hata alındı: \(error.localizedDescription)")
                return
            }

            guard let querySnapshot = querySnapshot else {
                print("Belgeler alınamadı.")
                return
            }

            var fetchedRuns: [[String: Any]] = []

            for document in querySnapshot.documents {
                let data = document.data()
                let km = data["km"] as? Double ?? 0.0
                let date = data["date"] as? String ?? ""
                let time = data["time"] as? Double ?? 0.0

                let runData: [String: Any] = ["km": km, "date": date, "time": time ]
                fetchedRuns.append(runData)
            }

            self.runsAim = fetchedRuns

            DispatchQueue.main.async {
                self.collectionViewVertical.reloadData()
            }
        }
    }
    
    private func getRunsFromFirestore(forUser user: User) {
        let firestoreDB = Firestore.firestore()

        guard let currentUserEmail = user.email else {
            print("Kullanıcının e-posta adresi yok.")
            return
        }

        firestoreDB.collection("users").document(currentUserEmail).collection("goalCompleted").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Hata alındı: \(error.localizedDescription)")
                return
            }

            guard let querySnapshot = querySnapshot else {
                print("Belgeler alınamadı.")
                return
            }

            var fetchedRuns: [[String: Any]] = []

            for document in querySnapshot.documents {
                let data = document.data()
                let km = data["km_done"] as? Double ?? 0.0
                let date = data["date"] as? String ?? ""
                let time = data["time_done"] as? Double ?? 0.0
                
                let aimDistance = 10.0

                let completionRate = Int((km / aimDistance) * 100)
                print("Tamamlanma yüzdesi: \(completionRate)%")
                
                let runData: [String: Any] = ["km_done": km, "date": date, "time_done": time ]
                fetchedRuns.append(runData)
            }

            self.runsDone = fetchedRuns

            DispatchQueue.main.async {
                self.collectionViewVertical.reloadData()
            }
        }
    }

//    self.updateProgressBars()
//

    private func setupViews() {
        view.addSubviews(labelHomeSecond, labelHomeThird, searchBar,collectionViewHorizontalTitleLabel, collectionViewHorizontal, collectionViewVerticaltitleLabel,collectionViewVertical)
        
        setupLayout()
    }
    
    private func setupLayout() {
        labelHomeThird.snp.makeConstraints ({ make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(15)
        })
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(labelHomeThird.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        collectionViewHorizontalTitleLabel.snp.makeConstraints({ make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(15)
        })
        
        collectionViewHorizontal.snp.makeConstraints ({ make in
            make.top.equalTo(collectionViewHorizontalTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(7)
            make.height.equalTo(200)
        })
        
        collectionViewVerticaltitleLabel.snp.makeConstraints({ make in
            make.top.equalTo(collectionViewHorizontal.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(15)
        })
        
        collectionViewVertical.snp.makeConstraints { make in
            make.top.equalTo(collectionViewVerticaltitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.height.equalTo(300)
        }
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == collectionViewHorizontal ? 5 : runsDone.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewVertical {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VerticalCell", for: indexPath) as! HomeCollectionViewVerticalCell
            let runData = runsDone[indexPath.item]
                
            if let dateString = runData["date"] as? String,
               let distance = runData["km_done"] as? Double {
                   cell.configure(date: dateString, distance: distance)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as! HomeCollectionViewHorizontalCell
            return cell
        }
    }




    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewHorizontal {
            return CGSize(width: 280, height: 174)
        } else {
            return CGSize(width: collectionView.frame.width - 30, height: 100)
        }
    }
}

extension HomeVC: ProfileInfoDelegate {
    func didReceiveName(_ name: String) {
        username = name
        labelHomeSecond.text = name
        labelHomeThird.text = "Günaydın \(name)"
    }
}
