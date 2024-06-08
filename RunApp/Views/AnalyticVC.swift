//
//  AnalyticVC.swift
//  RunApp
//
//  Created by d-datmaca on 5.03.2024.
// TODO: takvim biraz ileri alınabilir
// TODO: gün ortada durmuyor


import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
class AnalyticVC: UIViewController {
    
    let firestoreDB = Firestore.firestore()

    
    private lazy var calenderLabel: UILabel = {
        let label = UILabel()
        label.text = "mayıs 2024"
        return label
    }()

    private lazy var collectionViewHorizontal: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(CalenderCollectionViewCell.self, forCellWithReuseIdentifier: CalenderCollectionViewCell.reuseIdentifier)
            collectionView.backgroundColor = UIColor(named: "preLoginColor")
            collectionView.showsHorizontalScrollIndicator = false
            return collectionView
        }()

    
        
    private lazy var containerViewFirst: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "lila")
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(named: "lightPurple")?.cgColor

        return view
    }()
    private lazy var stackViewAim: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    

    private lazy var aimTodayLabel: UILabel = {
        let label = UILabel()
        label.text = "Bugünü Belirle !"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var kmTextField = AppTextField(title: "Bugün ne kadar km koşabilirsin?", placeholder: "5 KM", icon: nil, iconPosition: .none)
    private lazy var timeTextField = AppTextField(title: "Peki ne kadar sürede?", placeholder: "50 DK", icon: UIImage(named: "target"), iconPosition: .right)
    
    private lazy var containerViewSecond: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "lila")
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(named: "lightPurple")?.cgColor

        return view
    }()
    
    private lazy var stackViewDone: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()

    private let doneAimTodayLabel: UILabel = {
        let label = UILabel()
        label.text = "Bugünü nasıl tamamladın ?"
        label.textAlignment = .center
        return label
    }()
    private lazy var kmDoneTextField = AppTextField(title: "Bugün ne kadar km koştun?", placeholder: "5 KM", icon: nil, iconPosition: .none)
    private lazy var timeDoneTextField = AppTextField(title: "Ne kadar sürdü?", placeholder: "50 DK", icon: UIImage(named: "target"), iconPosition: .right)
    
    private lazy var startButton: UIButton = {
        let btn = AppButton()
        btn.setTitle("Başla", for: .normal)
        btn.iconPosition = .right
        btn.iconImage = UIImage(systemName: "figure.strengthtraining.functional")
        btn.buttonStyle = .light
        btn.iconTintColor = UIColor(named: "TabbarColor")
        btn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var doneButton: UIButton = {
        let btn = AppButton()
        btn.setTitle("Bitti", for: .normal)
        btn.iconPosition = .right
        btn.iconImage = UIImage(systemName: "figure.rolling")
        btn.iconTintColor = UIColor(named: "TabbarColor")
        btn.buttonStyle = .light
        btn.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let calendar = Calendar.current
    private var currentMonthStart: Date {
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        return calendar.date(from: components)!
    }
    
    @objc func startButtonTapped(){
        guard let currentUserEmail = Auth.auth().currentUser?.email,
              let kmText = kmTextField.textField.text,
              let timeText = timeTextField.textField.text,
              let km = Double(kmText),
              let time = Double(timeText) else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDate = dateFormatter.string(from: Date())
        
        firestoreDB.collection("users").document(currentUserEmail).collection("goalToday").addDocument(data: [
            "km": km,
            "time": time,
            "date" : currentDate
        ]) { error in
            if let error = error {
                print("Başlangıç koşusu verisi eklenirken hata oluştu: \(error)")
            } else {
                print("Başlangıç koşusu verisi başarıyla eklendi.")
                self.kmTextField.textField.text = ""
                self.timeTextField.textField.text = ""
            }
        }
    }

    @objc func doneButtonTapped(){
        guard let currentUserEmail = Auth.auth().currentUser?.email,
              let kmDoneText = kmDoneTextField.textField.text,
              let timeDoneText = timeDoneTextField.textField.text,
              let kmDone = Double(kmDoneText),
              let timeDone = Double(timeDoneText) else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDate = dateFormatter.string(from: Date())
        
        firestoreDB.collection("users").document(currentUserEmail).collection("goalCompleted").addDocument(data: [
            "km_done": kmDone,
            "time_done": timeDone,
            "date" : currentDate
        ]) { error in
            if let error = error {
                print("Tamamlanan koşu verisi eklenirken hata oluştu: \(error)")
            } else {
                print("Tamamlanan koşu verisi başarıyla eklendi.")
                self.kmDoneTextField.textField.text = ""
                self.timeDoneTextField.textField.text = ""
            }
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = UIColor(named: "preLoginColor")
        collectionViewHorizontal.dataSource = self
        collectionViewHorizontal.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToStartingItem()
    }

    private func scrollToStartingItem() {
        let currentDate = Date()
        let currentDay = calendar.component(.day, from: currentDate)
        let indexPath = IndexPath(item: currentDay - 1, section: 0)
        collectionViewHorizontal.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }



    private func setupViews() {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "LLLL yyyy"
        let monthString = monthFormatter.string(from: currentMonthStart)
        calenderLabel.text = monthString
        
        self.view.addSubviews(calenderLabel, collectionViewHorizontal, containerViewSecond, containerViewFirst)
        containerViewFirst.addSubview(stackViewAim)
        containerViewSecond.addSubview(stackViewDone)
        stackViewAim.addArrangedSubviews(aimTodayLabel, kmTextField, timeTextField, startButton)
        stackViewDone.addArrangedSubviews(doneAimTodayLabel, kmDoneTextField, timeDoneTextField, doneButton)
        setupLayout()
        
        if let flowLayout = collectionViewHorizontal.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
        }
    }
    
    func setupLayout() {
        calenderLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(90)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalTo(collectionViewHorizontal.snp.top)
        })
        
        collectionViewHorizontal.snp.makeConstraints({ make in
            make.top.equalTo(calenderLabel).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        })
        
        containerViewFirst.snp.makeConstraints({ make in
            make.top.equalTo(collectionViewHorizontal.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        })
        
        stackViewAim.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        })
        
        containerViewSecond.snp.makeConstraints({ make in
            make.top.equalTo(stackViewAim.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        })
        
        stackViewDone.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        })
        
        doneButton.snp.makeConstraints({ make in
            make.height.equalTo(50)
        })
        startButton.snp.makeConstraints({ make in
            make.height.equalTo(50)
        })
    }
}

extension AnalyticVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let range = calendar.range(of: .day, in: .month, for: currentMonthStart) else {
            return 0
        }
        return range.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalenderCollectionViewCell.reuseIdentifier, for: indexPath) as? CalenderCollectionViewCell,
              let date = dateForIndexPath(indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.dateForCell = date
        updateCalenderLabel(for: indexPath)
        return cell
    }

    private func updateCalenderLabel(for indexPath: IndexPath) {
        guard let date = dateForIndexPath(indexPath) else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "tr_TR") // Burası tr için
        dateFormatter.dateFormat = "LLLL yyyy"
        let monthString = dateFormatter.string(from: date)
        
        calenderLabel.text = monthString
    }


    private func dateForIndexPath(_ indexPath: IndexPath) -> Date? {
        guard let startDate = calendar.date(byAdding: .day, value: indexPath.row, to: currentMonthStart) else {
            return nil
        }
        return startDate
    }
}
