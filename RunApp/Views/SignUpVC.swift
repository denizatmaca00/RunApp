//
//  SignUpVC.swift
//  RunApp
//
//  Created by d-datmaca on 4.03.2024.
//
 // TODO: arkaplana map koy görüntü olarak opacityde azalt belki?
import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class SignUpVC: UIViewController {
    
  //  var signUpData: User = User(full_name: "", email: "", password: "")
    
    
    private lazy var nameTextField = AppTextField(title: "Adınız", placeholder: "Example", icon: nil, iconPosition: .none)
    private lazy var surnameTextField = AppTextField(title: "Soyadınız", placeholder: "Example", icon: nil, iconPosition: .none)
    private lazy var usernameTextField = AppTextField(title: "Kullanıcı Adı", placeholder: "username_example", icon: nil, iconPosition: .none)
    private lazy var emailTextField = AppTextField(title: "Email", placeholder: "example@gmail.com", icon: nil, iconPosition: .none)
    private lazy var passwordTextField = AppTextField(title: "Password", placeholder: "*******", icon: UIImage(systemName: "eye.slash.fill"), iconPosition: .right)
    private lazy var passwordConfirmTextField = AppTextField(title: "Password Confirm", placeholder: "*******", icon: UIImage(systemName: "eye.slash.fill"), iconPosition: .right)
    
    private lazy var signUpLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "ÜYE OL"
        lbl.textColor = UIColor(named: "ThemeColorSecond")
        lbl.font = UIFont(name: "Lato-Black", size: 20)
        return lbl
    }()
    
    private lazy var stackViewMain: UIStackView = {
        let stackViews = UIStackView()
//        stackViews.backgroundColor = UIColor(named: "ThemeColor")
        self.view.backgroundColor = UIColor(named: "pastelGray1")
        stackViews.axis = .vertical
        stackViews.spacing = 24

        return stackViews
    }()
    
    private lazy var signUpButton: UIButton = {
        let signUpButton = AppButton()
        signUpButton.setTitle("Üye Ol", for: .normal)
        signUpButton.buttonStyle = .normal
        signUpButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)

        signUpButton.isEnabled = true
        return signUpButton
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
       }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
//     @objc func signupButtonTapped(){
//         if emailTextField.textField.text != "" && passwordTextField.textField.text != "" {
//             Auth.auth().createUser(withEmail: emailTextField.textField.text!, password: passwordTextField.textField.text!) { (authData, error) in
//                  if error != nil{
//                     print("yanlşış")
//                  }else {
//                      if self.emailTextField.textField.text != "" && self.passwordTextField.textField.text != "" {
//                          Auth.auth().signIn(withEmail: self.emailTextField.textField.text!, password: self.passwordTextField.textField.text!){(authData, error) in
//                              if error != nil{
//                                  print("error")
//                              } else {
//                                  let vc = LoginVC()
//                                  self.navigationController?.pushViewController(vc, animated: true)
//                              }
//                          }
//                      }
//                  }
//              }
//          } else {
//              print("usaername ya da password geçersiz çiçeğşm")
//          }
//         
//         let firestoreDatabase = Firestore.firestore()
//         var firestoreReference: DocumentReference? = nil
//         
//         let firestoreProfileInfos = ["name": nameTextField.textField.text, "surname":surnameTextField.textField.text, "userName": usernameTextField.textField.text, "email": emailTextField.textField.text, "password": passwordTextField.textField.text]
//         
//         firestoreReference = firestoreDatabase.collection("profileInfos").addDocument(data: firestoreProfileInfos, completion: { (error) in
//             if error != nil{
//                 print(error?.localizedDescription ?? "error")
//             }
//             
//         })
//    }
    
    @objc func signupButtonTapped() {
        guard let email = emailTextField.textField.text, !email.isEmpty,
              let password = passwordTextField.textField.text, !password.isEmpty,
              let name = nameTextField.textField.text,
              let surname = surnameTextField.textField.text,
              let username = usernameTextField.textField.text
        else {
            print("E-posta, şifre, ad, soyad ve kullanıcı adı boş olamaz")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }

            let firestoreDatabase = Firestore.firestore()
            firestoreDatabase.collection("profileInfos").addDocument(data: [
                "name": name,
                "surname": surname,
                "userName": username,
                "email": email,
            ]) { (error) in
                if let error = error {
                    print("Firestore Hata: \(error.localizedDescription)")
                    return
                }
                let vc = LoginVC()
                self.navigationController?.pushViewController(vc, animated: true)

            }
        }
    }

    
    func setupViews() {
        usernameTextField.textField.autocapitalizationType  = .words
        
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.autocorrectionType = .no
        emailTextField.textField.autocapitalizationType = .none
        
        passwordTextField.textField.isSecureTextEntry = true
        passwordConfirmTextField.textField.isSecureTextEntry = true
        
//        self.view.backgroundColor = UIColor(named: "ThemeColor")
        self.view.backgroundColor = .darkGray
        self.view.addSubviews(signUpLabel,stackViewMain ,signUpButton)
        stackViewMain.addArrangedSubviews(nameTextField,surnameTextField, usernameTextField,emailTextField, passwordTextField, passwordConfirmTextField)

        
        setupLayout()
    }
    
    func setupLayout() {
        let limits = self.view.safeAreaLayoutGuide.snp
        
        signUpLabel.snp.makeConstraints({ lbl in
            lbl.centerX.equalToSuperview()
            lbl.top.equalTo(limits.top)
        })
        
        stackViewMain.snp.makeConstraints { stack in
            stack.leading.equalToSuperview().offset(24)
            stack.trailing.equalToSuperview().offset(-24)
            stack.top.equalTo(signUpLabel).offset(50)
        }
        
        signUpButton.snp.makeConstraints({ btn in
            btn.bottom.equalTo(limits.bottom).offset(-23)
            btn.trailing.equalToSuperview().offset(-24)
            btn.leading.equalToSuperview().offset(24)
            btn.height.equalTo(54)
        })
    }
}

extension SignUpVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)->Bool
    {
        if textField == emailTextField.textField && textField.text?.count == 21
        {
            return false
        }
        else if textField == passwordTextField.textField && textField.text?.count == 21
        {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
   
    func checkPassMatch()->Bool{
        
        let isEmpty = checkIsEmpty()
        
        if passwordTextField.textField.text == passwordConfirmTextField.textField.text && isEmpty != false
        {
            signUpButton.isEnabled = true
            return true
        }
        else{
            signUpButton.isEnabled = true
            return false}
    }
    
    func checkIsEmpty()->Bool?
    {
        if usernameTextField.textField.text == "" ||
            emailTextField.textField.text == "" ||
            passwordTextField.textField.text == "" ||
            passwordConfirmTextField.textField.text == ""
        {
            return false
        }
        else if passwordTextField.textField.text!.count < 6 {
            return false
        }
        else
        {
            return true
        }
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct SignUpVC_Preview: PreviewProvider {
    static var previews: some View{
        
        SignUpVC().showPreview()
    }
}
#endif
