//
//  ProfileInfoCollectionViewCell.swift
//  RunApp
//
//  Created by d-datmaca on 6.03.2024.
//
//TODO: bilgi alımları burdan home a giden ussername var ona göre tekrar bir düzenleme gerekecek
import UIKit
import SnapKit
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth

protocol ProfileInfoDelegate: AnyObject {
    func didReceiveName(_ name: String)
}


class ProfileInfoCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "ProfileInfoCollectionViewCell"
    
    
    weak var delegate: ProfileInfoDelegate?

    var userName: String = "" {
        didSet {
            delegate?.didReceiveName(userName)
        }
    }

    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ThemeColor")
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        
        return view
    }()
    
    private lazy var stackViewProfile: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 5
        sv.axis = .vertical
        sv.backgroundColor = .clear
        sv.distribution = .fill
        sv.alignment = .center
        return sv
    }()
    
    private lazy var viewProfilePhoto: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "preLoginColor")
        view.layer.cornerRadius = 50
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        return view
    }()
    
    private lazy var imageProfilPhoto: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person")
        image.tintColor = .black
        return image
    }()
    
    private let labelNameSurname: UILabel = {
        let label = UILabel()
        label.text = "İsim Soyisim"
        label.font = UIFont(name: "Arial", size: 18)

        return label
    }()
    
    private lazy var buttonEditProfile: UIButton = {
        let btn = AppButton()
        btn.setTitle("Düzenle", for: .normal)
        btn.buttonStyle = .light
        btn.addTarget(self, action: #selector(buttonEditProfileTapped), for: .touchUpInside)
        btn.layer.cornerRadius = 6
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    private lazy var viewSpace: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonEditProfileTapped(){
    //    let vc = PreLoginVC()
      //  self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getProfileInfosFromFB(){
        let firestoreDB = Firestore.firestore()
        
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            return // Kullanıcı oturum açmamışsa, işlemi sonlandır
        }
        
        firestoreDB.collection("profileInfos").whereField("email", isEqualTo: currentUserEmail).getDocuments { (snapshot, error) in
            if let error = error {
                print("Belgeleri alırken hata oluştu: \(error)")
                return
            }

            guard let snapshot = snapshot else {return}

            for document in snapshot.documents {
                let name = document.get("name") as? String ?? ""
                let surname = document.get("surname") as? String ?? ""
                let fullName = "\(name) \(surname)"
                self.userName = document.get("userName") as? String ?? ""

                DispatchQueue.main.async {
                    self.labelNameSurname.text = fullName
                }
            }
        }
    }
   

   


    private func setupViews() {
        self.contentView.addSubview(containerView)
        containerView.addSubviews(stackViewProfile)
        viewProfilePhoto.addSubview(imageProfilPhoto)
        stackViewProfile.addArrangedSubviews(viewProfilePhoto, labelNameSurname, buttonEditProfile, viewSpace)
        setupLayout()
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        imageProfilPhoto.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        stackViewProfile.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        buttonEditProfile.snp.makeConstraints({ make in
            make.height.equalTo(25)
            make.width.equalTo(90)
        })
        viewProfilePhoto.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(10)
            make.height.width.equalTo(100)
        })
    }
    
    
}
