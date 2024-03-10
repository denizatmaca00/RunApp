//
//  HomeCollectionViewHorizontalCell.swift
//  RunApp
//
//  Created by d-datmaca on 5.03.2024.
//

import UIKit

class HomeCollectionViewHorizontalCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "HomeCollectionViewHorizontalCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(named: "TabbarColor")?.cgColor

        return view
    }()
    
//    private lazy var labelPlacesTitle = AppLabel(icon: nil, text: "MAltepe Sahil", alignment: .none)
    private lazy var labelPlacesTitle : UILabel = {
        let label = UILabel()
        label.text = "Maltepe Sahil"
        label.textColor = .white
        label.font = UIFont(name: "Arial Bold", size: 24)
        return label
    }()
    
    private lazy var labelKm = AppLabel(icon: UIImage(named: "cal"), text: "3km", alignment: .left)
    private lazy var labelMinute = AppLabel(icon: UIImage(named: "time"), text: "50dk", alignment: .left)

    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "PlacesImage1")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubviews(imageView)
        imageView.addSubviews(labelPlacesTitle, labelKm, labelMinute)
        setupLayout()
        
    }
    func setupLayout(){
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        labelPlacesTitle.snp.makeConstraints({make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(12)
        })
        
        labelKm.snp.makeConstraints({make in
            make.top.equalTo(labelPlacesTitle.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(12)
        })
        
        labelMinute.snp.makeConstraints({make in
            make.top.equalTo(labelKm.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(12)
        })
    }
    
    func configure(withText text: String, image: UIImage) {
//        label.text = text
        imageView.image = image
    }
}
