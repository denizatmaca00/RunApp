//
//  LoginVC.swift
//  RunApp
//
//  Created by d-datmaca on 4.03.2024.
// TODO: arkaplana map gömülebilir
// TODO: logo tamamlansın (yazı şeklinde)
// TODO: tectfield iconunu sola alabiliriz
// TODO: beni hatırla ekle
// TODO: prelogini splashscreen olayına bir bak daha önce loginse orası hızlı geçsin

import UIKit
import SnapKit
import FirebaseAuth

    
class LoginVC: UIViewController {
    //MARK: Private Components
    
    private lazy var imageLoginLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        return image
    }()
    
    private lazy var emailTextField = AppTextField(title: "Email", placeholder: "example@gmail.com", icon: nil, iconPosition: .none)
    private lazy var passwordTextField = AppTextField(title: "Password", placeholder: "*******", icon: UIImage(systemName: "eye.slash.fill"), iconPosition: .right)
    
    private lazy var stackViewMain: UIStackView = {
        let stackViews = UIStackView()
//        stackViews.backgroundColor = UIColor(named: "ThemeColor")
        self.view.backgroundColor = UIColor(named: "preLoginColor")
        stackViews.axis = .vertical
        stackViews.spacing = 24
        return stackViews
    }()
    
    private lazy var loginButton: UIButton = {
        let btn = AppButton()
        btn.setTitle("Başla", for: .normal)
        btn.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        btn.buttonStyle = .normal
        btn.isEnabled = true
        return btn
    }()
    
    private lazy var leftBarButton: UIBarButtonItem = {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButton.tintColor = .black

        return leftBarButton
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let startColor = UIColor(named: "preLoginColor")?.withAlphaComponent(0.5).cgColor
        let endColor = UIColor(named: "preLoginColor")?.withAlphaComponent(0.3).cgColor
        gradientLayer.colors = [startColor, endColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.autocorrectionType = .no
        emailTextField.textField.autocapitalizationType = .none
    }
    //MARK: Functions
    
    @objc func loginButtonTapped(){
        
        if emailTextField.textField.text != "" && passwordTextField.textField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.textField.text!, password: passwordTextField.textField.text!) {
                (authData, error) in
                if(error != nil){
                    AppAlert.showAlert(title: "Hata", message: "Bilgileri yanlış girdiniz.", type: .error, viewController: self)
                } else{
                    let vc = TabbarVC()
                    self.navigationController?.pushViewController(vc, animated: true)                }
            }
        }
        
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        
        emailTextField.textField.autocapitalizationType  = .words
        passwordTextField.textField.isSecureTextEntry = true
        
//        self.view.backgroundColor = UIColor(named: "ThemeColor")
        self.view.backgroundColor = .darkGray
        self.view.addSubviews(imageLoginLogo, stackViewMain ,loginButton)
        stackViewMain.addArrangedSubviews(emailTextField, passwordTextField)
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
        imageLoginLogo.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(180)
            make.leading.equalToSuperview().offset(100)
            make.trailing.equalToSuperview().offset(-100)
            make.height.equalTo(100)
            
        })
        stackViewMain.snp.makeConstraints { stack in
            stack.leading.equalToSuperview().offset(24)
            stack.trailing.equalToSuperview().offset(-24)
            stack.top.equalTo(imageLoginLogo).offset(220)
        }
        
        loginButton.snp.makeConstraints({ btn in
            btn.bottom.equalTo(limits.bottom).offset(-23)
            btn.trailing.equalToSuperview().offset(-24)
            btn.leading.equalToSuperview().offset(24)
            btn.height.equalTo(54)
        })
    }
}



#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct LoginVC_Preview: PreviewProvider {
    static var previews: some View{
        
        LoginVC().showPreview()
    }
}
#endif
