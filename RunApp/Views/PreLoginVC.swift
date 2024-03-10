//
//  ViewController.swift
//  RunApp
//
//  Created by d-datmaca on 4.03.2024.
// TODO: koşan adam animasyonu eklenebilir.

import UIKit
import SnapKit
class PreLoginVC: UIViewController {
    
    private lazy var imagePreLogin: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "firstScreenImage")
        return image
    }()
    private lazy var imagePreLoginOverlay: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "shadowOverlay")
        return image
    }()
    
    private lazy var labelSlogan: UILabel = {
        let lbl = UILabel()
        lbl.text = "Nerede Olursan Ol Koşu Her Zaman Yanında"
        lbl.numberOfLines = 2
        lbl.textColor = .black
        lbl.font = UIFont(name: "Arial Bold", size: 25)
        lbl.textAlignment = .center

        return lbl
    }()
    
    private lazy var labelSloganSecond: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sağlığı yakalamak için koşmalısın"
        lbl.textColor = .gray
        lbl.font = UIFont(name: "Arial Italic", size: 12)
     //   lbl.font = UIFont(name: "Lato-ThinItalic", size: 4)
        return lbl
    }()
    
    private lazy var imageLoadingBar: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "figure.run")
        image.tintColor = UIColor(named: "ThemeColorIcon")
        return image
    }()
    
    private lazy var stackViewOfLabels: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 20
        sv.axis = .vertical
        sv.backgroundColor = .clear
        sv.alignment = .center
        sv.distribution = .fill

        return sv
    }()
    
    private lazy var buttonSignInStart: UIButton = {
        let btn = AppButton()
        btn.setTitle("Giriş Yap", for: .normal)
        btn.buttonStyle = .normal
        btn.addTarget(self, action: #selector(buttonSignInStartTapped), for: .touchUpInside)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    private lazy var buttonSignUp: UIButton = {
        let btn = AppButton()
        btn.setTitle("Üyeliğin yok mu? Koş!", for: .normal)
        btn.buttonStyle = .dark
        btn.addTarget(self, action: #selector(buttonSignUpTapped), for: .touchUpInside)
        btn.setTitleColor(.white, for: .normal)
        
        return btn
    }()
    
    private lazy var stackViewOfButtons: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 10
        sv.axis = .vertical
        sv.backgroundColor = .clear
        sv.distribution = .fillEqually
        return sv
    }()
        
    @objc func buttonSignInStartTapped(){
        let vc = LoginVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonSignUpTapped(){
        let vc = SignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubviews(imagePreLogin,imagePreLoginOverlay,stackViewOfLabels, stackViewOfButtons)
        stackViewOfLabels.addArrangedSubviews(labelSlogan, labelSloganSecond, imageLoadingBar)
        stackViewOfButtons.addArrangedSubviews(buttonSignInStart, buttonSignUp )
        setupLayout()
    }
    
    
    func setupLayout() {
        
       // let limits = self.view.safeAreaLayoutGuide.snp
        
        imagePreLogin.snp.makeConstraints({make in
            make.top.equalToSuperview().inset(-45)
            make.height.equalTo(565)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        })
        imagePreLoginOverlay.snp.makeConstraints({ make in
            make.bottom.equalTo(imagePreLogin.snp.bottom)
            make.height.equalTo(175)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            
        })
        stackViewOfLabels.snp.makeConstraints({make in
            make.top.equalTo(imagePreLogin.snp.bottom)
            make.trailing.equalToSuperview().offset(-50)
            make.leading.equalToSuperview().offset(50)
        })
        stackViewOfButtons.snp.makeConstraints({ make in
            make.top.equalTo(stackViewOfLabels.snp.bottom).offset(30)
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-50)
        })
        
        buttonSignInStart.snp.makeConstraints({make in
            make.height.equalTo(50)
        })
    }
    
}

