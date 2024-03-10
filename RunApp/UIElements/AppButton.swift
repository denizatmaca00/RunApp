//
//  AppButton.swift
//  RunApp
//
//  Created by d-datmaca on 4.03.2024.
//


import UIKit

enum ButtonStyle {
    case light
    case normal
    case dark
    
    var backgroundColor: UIColor? {
        switch self {
        case .light:
            return UIColor(named: "pink")
        case .normal:
            return UIColor(named: "ThemeColor")
        case .dark:
            return UIColor(named: "TabbarColor")
        }
    }
}

enum IconPosition {
    case left
    case right
    case none
}

class AppButton: UIButton {
    
    var buttonStyle: ButtonStyle = .normal {
        didSet {
            defineBackgroundColor()
        }
    }
    
    var iconImage: UIImage? {
        didSet {
            if let iconImage = iconImage {
                self.setImage(iconImage, for: .normal)
            } else {
                self.setImage(nil, for: .normal)
            }
        }
    }
    
    var iconPosition: IconPosition = .left {
        didSet {
            positionIcon()
        }
    }
    
    var iconTintColor: UIColor? {
        didSet {
            self.tintColor = iconTintColor
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 24
        self.titleLabel?.font = UIFont(name: "Arial", size: 15)
        self.setTitleColor(.black, for: .normal)
        self.buttonStyle = .normal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineBackgroundColor() {
        self.backgroundColor = buttonStyle.backgroundColor
    }
    
    private func positionIcon() {
        switch iconPosition {
        case .left:
            self.semanticContentAttribute = .forceLeftToRight
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        case .right:
            self.semanticContentAttribute = .forceRightToLeft
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        case .none:
            self.setImage(nil, for: .normal)
        }
    }
}
