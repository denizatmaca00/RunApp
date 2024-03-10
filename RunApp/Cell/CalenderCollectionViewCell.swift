//
//  CalenderCollectionViewCell.swift
//  RunApp
//
//  Created by d-datmaca on 5.03.2024.
//
import UIKit

class CalenderCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "CalenderCollectionViewCell"
    
    let turkishWeekdaySymbols = ["P", "P", "S", "Ç", "P", "C", "C"]

    
    private lazy var viewDay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ThemeColor")
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var labelWeekDay: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "TabbarColor")
        label.text = "S"
        label.font = UIFont(name: "Arial", size: 10)

        return label
    }()
    private lazy var labelMonthNumber: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "TabbarColor")
        label.text = "10"
        label.font = UIFont(name: "Arial", size: 10)
        return label
    }()
    
    private lazy var dotView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(named: "TabbarColor")
            view.layer.cornerRadius = 2
            return view
        }()
        
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        sv.distribution = .fillEqually
        return sv
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dateForCell: Date? {
            didSet {
                configure()
            }
        }
    
    private func setupViews() {
        // Add subviews
        contentView.addSubviews(viewDay)
        viewDay.addSubview(stackView)
        stackView.addArrangedSubviews(labelWeekDay, labelMonthNumber)
        viewDay.addSubview(dotView)
        setupLayout()
        
        
    }
    func setupLayout(){
        viewDay.snp.makeConstraints({ make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 2, bottom: 8, right: 8))
        })
        stackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        })
        dotView.snp.makeConstraints({ make in
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview().offset(10)
                    make.width.height.equalTo(4)
                })

    }
    private func configure() {
            guard let date = dateForCell else { return }
            let dayOfMonth = Calendar.current.component(.day, from: date)
            let weekday = Calendar.current.component(.weekday, from: date)
            
            labelWeekDay.text = turkishWeekdaySymbols[weekday - 1]
            labelMonthNumber.text = "\(dayOfMonth)"
            
            // Control today's date
            let currentDate = Date()
            let currentDayOfMonth = Calendar.current.component(.day, from: currentDate)
            let currentMonth = Calendar.current.component(.month, from: currentDate)
            
            let cellDayOfMonth = Calendar.current.component(.day, from: date)
            let cellMonth = Calendar.current.component(.month, from: date)
            
        if cellDayOfMonth == currentDayOfMonth && cellMonth == currentMonth {
                    viewDay.backgroundColor = .black
                    labelWeekDay.textColor = .white
                    labelMonthNumber.textColor = .white
                    dotView.isHidden = false
                } else {
                    viewDay.backgroundColor = UIColor(named: "ThemeColor")
                    labelWeekDay.textColor = UIColor(named: "TabbarColor")
                    labelMonthNumber.textColor = UIColor(named: "TabbarColor")
                    dotView.isHidden = true
                }
        }
}
