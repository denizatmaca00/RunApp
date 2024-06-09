//
//  AppAlert.swift
//  RunApp
//
//  Created by Deniz ATMACA on 9.06.2024.
//

import UIKit

enum AlertType {
    case info
    case warning
    case error
    
    var backgroundColor: UIColor {
        switch self {
        case .info:
            return UIColor(named: "preLoginColor") ?? .white
        case .warning:
            return UIColor(named: "preLoginColor") ?? .white
        case .error:
            return UIColor(named: "preLoginColor") ?? .white
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .info:
            return UIColor(named: "lightPurple") ?? .blue
        case .warning:
            return UIColor(named: "ThemeColor") ?? .orange
        case .error:
            return .red
        }
    }
}

class AppAlert {
    static func showAlert(title: String?, message: String?, type: AlertType, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.backgroundColor = type.backgroundColor
        
        let titleAttributedString = NSAttributedString(string: title ?? "", attributes: [NSAttributedString.Key.foregroundColor : type.titleColor])
        alertController.setValue(titleAttributedString, forKey: "attributedTitle")
        
        let messageAttributedString = NSAttributedString(string: message ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        alertController.setValue(messageAttributedString, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: "Kapat", style: .default, handler: nil)
        okAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
