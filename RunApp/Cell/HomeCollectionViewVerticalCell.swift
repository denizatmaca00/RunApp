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
    
    static let reuseIdentifier: String = "HomeCollectionViewVerticalCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(named: "TabbarColor")?.cgColor
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fill
        return sv
        
    }()
    private lazy var descStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .equalSpacing
        return sv
        
    }()
    
    private let label0: UILabel = {
        let label = UILabel()
        return label
    }()
    private let label1: UILabel = {
        let label = UILabel()
        label.text = "01.01.2020"
        label.font = UIFont(name: "Arial Bold", size: 12)
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.text = "5 km koştun"
        label.font = UIFont(name: "Arial", size: 12)

        return label
    }()
    
    private let label4: UILabel = {
        let label = UILabel()
        return label
    }()
    private let label3: UILabel = {
        let label = UILabel()
        label.text = "%50"
        label.font = UIFont(name: "Arial", size: 12)
        label.textColor = UIColor(named: "TabbarColor")
        return label
    }()

    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor(named: "ThemeColor")
        progressView.trackTintColor = UIColor(named: "pastelGray2")
        progressView.layer.cornerRadius = 4
        progressView.layer.borderWidth = 0.2
        progressView.clipsToBounds = true
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 3) // Yükseklik ayarı
        progressView.progress = 0.5 // Yüzde ayarı
        return progressView
    }()

    private lazy var progressBarContainer: UIView = {
        let view = UIView()
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()

    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "PlacesImage2")
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let viewImage: UIView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
//        view.layer.cornerRadius = 16
//        view.layer.masksToBounds = true
        return view
    }()
    
//    private let viewForSpace: UIView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainStackView)
        viewImage.addSubview(imageView)
        mainStackView.addArrangedSubviews(viewImage, descStackView)
        descStackView.addArrangedSubviews(label0,label1, label2, progressBarContainer, label4)
        progressBar.addSubviews(label3)
        setupLayout()
    }
    func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainStackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        imageView.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(90)
        })
        descStackView.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        })
        progressBarContainer.snp.makeConstraints({ make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        })
        
    }
    
    func configure(date: String, distance: Double) {
        label1.text = date // Tarih burada ayarlanıyor
        label2.text = "\(distance) km koştun"
    }
    
    func updateProgressBar(completionPercentage: Double) {
            // Progres barı güncelleniyor
            progressBar.progress = Float(completionPercentage / 100)
            label3.text = "\(Double(completionPercentage))%"
        print(completionPercentage)
        }
}
