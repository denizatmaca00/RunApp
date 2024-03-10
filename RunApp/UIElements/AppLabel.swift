//
//  AppLabel.swift
//  RunApp
//
//  Created by d-datmaca on 5.03.2024.
//

import UIKit

enum IconAlignment {
    case left
    case right
    case none
}

class AppLabel: UIView {
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
     lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "TabbarColor")
       // label.font = .Fonts.textFieldText.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var viewWithBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.shadow()
        return view
    }()
    
    init(icon: UIImage?, text: String, alignment: IconAlignment) {
        super.init(frame: .zero)
        
        var updatedAlignment = alignment
        
        if let icon = icon {
            iconImageView.image = icon
        } else {
            updatedAlignment = .none
        }
        
        textLabel.text = text
        
        viewWithBorder.backgroundColor = UIColor(named: "ThemeColor")
        viewWithBorder.layer.opacity = 1
        viewWithBorder.addSubviews(iconImageView, textLabel)
        addSubview(viewWithBorder)
        
        setupConstraints(updatedAlignment)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(_ alignment: IconAlignment) {
        viewWithBorder.snp.makeConstraints { view in
            view.leading.equalToSuperview()
            view.centerY.equalToSuperview()
            view.height.equalTo(25)
            view.width.equalTo(75)
        }
        
        iconImageView.snp.makeConstraints { icon in
            icon.width.equalTo(13)
            icon.height.equalTo(13)
            icon.centerY.equalToSuperview()
            icon.leading.equalTo(viewWithBorder.snp.leading).offset(8)
        }
        
        textLabel.snp.makeConstraints { lbl in
            switch alignment {
            case .left:
                lbl.leading.equalTo(iconImageView.snp.trailing).offset(8)
                lbl.centerY.equalToSuperview()
            case .right:
                lbl.leading.equalToSuperview().offset(8)
                lbl.centerX.equalTo(viewWithBorder)
                lbl.centerY.equalToSuperview()
            case .none:
                lbl.leading.equalToSuperview().offset(8)
                lbl.trailing.equalToSuperview().inset(8)
                lbl.centerY.equalToSuperview()
            }
        }
    }
}

extension UILabel{
    func getHeaderLabel(text:String)->UILabel{
        lazy var lblHeader:UILabel = {
            let lbl = UILabel()
        //    lbl.font = .Fonts.pageHeader36.font
            lbl.textColor = UIColor(named: "textColorReversed")
            lbl.text = text
            return lbl
        }()
        return lblHeader
    }
}
