//
//  ProfileInfoVC.swift
//  RunApp
//
//  Created by Deniz ATMACA on 9.06.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol ProfileInfoVCDelegate: AnyObject {
    func didReceiveName(_ name: String)
}


class ProfileInfoVC: UIViewController {

    weak var delegate: ProfileInfoVCDelegate?
    
    var username: String = "" {
        didSet {
            delegate?.didReceiveName(username)
        }
    }

    private var nameLabel: AppTextField!
    private var emailTextField: AppTextField!
    private var passwordTextField: AppTextField!

    private let firestoreDB = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profil Bilgilerim"
        view.backgroundColor = .white

        setupTextFields()
        fetchProfileInfo()
    }

    private func setupTextFields() {
        nameLabel = AppTextField(title: "Ad Soyad", placeholder: "", icon: nil, iconPosition: .none)
        emailTextField = AppTextField(title: "E-posta", placeholder: "", icon: nil, iconPosition: .none)
        passwordTextField = AppTextField(title: "Şifre", placeholder: "", icon: nil, iconPosition: .none)
        
        nameLabel.titleLbl.textColor = UIColor(named: "ThemeColor")
        emailTextField.titleLbl.textColor = UIColor(named: "ThemeColor")
        passwordTextField.titleLbl.textColor = UIColor(named: "ThemeColor")
        nameLabel.titleLbl.font = UIFont.boldSystemFont(ofSize: 15)
        emailTextField.titleLbl.font = UIFont.boldSystemFont(ofSize: 15)
        passwordTextField.titleLbl.font = UIFont.boldSystemFont(ofSize: 15)
        passwordTextField.textField.isSecureTextEntry = true



        let stackView = UIStackView(arrangedSubviews: [nameLabel, emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }

        
    }

    private func fetchProfileInfo() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            return // Kullanıcı oturum açmamışsa, işlemi sonlandır
        }

        firestoreDB.collection("profileInfos").whereField("email", isEqualTo: currentUserEmail).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }

            if let error = error {
                print("Belgeleri alırken hata oluştu: \(error)")
                return
            }

            guard let snapshot = snapshot else { return }

            for document in snapshot.documents {
                let name = document.get("name") as? String ?? ""
                let surname = document.get("surname") as? String ?? ""
                let fullName = "\(name) \(surname)"
                let email = document.get("email") as? String ?? ""
                let password = document.get("password") as? String ?? ""
                

                DispatchQueue.main.async {
                    self.nameLabel.textField.text = fullName
                    self.emailTextField.textField.text = email
                    self.passwordTextField.textField.text = password
                }
            }
        }
    }
}
//func fetchProfileInfo() {
//    let firestoreDB = Firestore.firestore()
//    
//    guard let currentUserEmail = Auth.auth().currentUser?.email else {
//        return // Kullanıcı oturum açmamışsa, işlemi sonlandır
//    }
//    
//    firestoreDB.collection("profileInfos").whereField("email", isEqualTo: currentUserEmail).getDocuments { (snapshot, error) in
//        if let error = error {
//            print("Belgeleri alırken hata oluştu: \(error)")
//            return
//        }
//
//        guard let snapshot = snapshot else {return}
//
//        for document in snapshot.documents {
//            let name = document.get("name") as? String ?? ""
//            let surname = document.get("surname") as? String ?? ""
//            let fullName = "\(name) \(surname)"
//            let email = document.get("email") as? String ?? ""
//            let password = document.get("password") as? String ?? ""
//            self.username = document.get("userName") as? String ?? ""
//            
//            DispatchQueue.main.async {
//                self.nameLabel.textField.text = fullName
//                self.emailTextField.textField.text = email
//                self.passwordTextField.textField.text = password
//            }
//        }
//    }
//}
