//
//  HomeCollectionViewVerticalCell.swift
//  RunApp
//
//  Created by d-datmaca on 5.03.2024.
//  TODO: puan eklenecek
// TODO: barda % lik gözükecek
// TODO: önceki koşulara filtreleme eklenecek (km bazlı)

import UIKit

class HomeCollectionViewVerticalCell: UICollectionViewCell {
    static let reuseIdentifier = "VerticalCell"
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        contentView.addSubviews(dateLabel, distanceLabel, timeLabel)
        
        setupLayout()
    }
    
    private func setupLayout() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(8)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(date: Date, distance: Double) {
        // Date formatını ayarla
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)

        // Label'lara değerleri ata
        dateLabel.text = dateString
        distanceLabel.text = "\(distance) km"
        
    }

}
