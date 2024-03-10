//
//  Extensions.swift
//  RunApp
//
//  Created by d-datmaca on 4.03.2024.
//

import UIKit
import Foundation
import SwiftUI


// MARK: - Format Type
enum FormatType:String {
    case longFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case longWithoutZone = "yyyy-MM-dd'T'HH:mm:ss"
    case withoutYear = "dd MMMM"
    case localeStandard = "dd.MM.yyyy"
    case standard = "yyyy-MM-dd"
    case dateAndTime = "dd.MM.yyyy'T'HH:mm"
    case time = "HH:mm"
}

// MARK: - Font Type
enum FontType:String {
    case bold = "Bold"
    case medium = "Medium"
}

// MARK: - UIStack View
extension UIStackView {
    func addArrangedSubviews(_ view: UIView...) {
        view.forEach({ v in
            self.addArrangedSubview(v)
        })
    }
}

// MARK: - UIView
extension UIView {
    /// Add multiple subview to a view.
    /// - Parameter view: It is a subviews array which add to parent view
    func addSubviews(_ view: UIView...) {
        view.forEach({ v in
            self.addSubview(v)
        })
    }
    
    @available(iOS 13, *)
    private struct Preview: UIViewRepresentable {
        typealias UIViewType = UIView
        let view: UIView
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            //
        }
    }
    
    @available(iOS 13, *)
    func showPreview() -> some View {
        // inject self (the current UIView) for the preview
        Preview(view: self)
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = 0.4
        animation.values = [-10.0, 5.0, -5.0, 0.0]
        
        layer.add(animation, forKey: "shake")
    }
    
    func addView() ->UIView{
        let view = UIView()
        self.addSubview(view)
        return view
    }
    
    func addLabel(text:String? = nil, fontSize: CGFloat = 14, fontType:FontType = .medium, color:UIColor = .black, align:NSTextAlignment = .left) ->UILabel {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-\(fontType.rawValue)", size: fontSize)
        label.textColor = color
        label.text = text
        self.addSubview(label)
        return label
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
    }
    
    func addDashedBorder(color: UIColor) {
        let color = color.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width-2, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: (frameSize.width / 2), y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4, 4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
        self.layer.addSublayer(shapeLayer)
    }
    func shadow(){
        self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 4, height: 0)
            self.layer.shadowRadius = 6
            self.layer.shadowOpacity = 0.15
            self.layer.masksToBounds = false
    }
    
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
    
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}

// MARK: - UITextField
extension UITextField {
    
    enum TextType {
        case emailAddress
        case password
        case generic
    }
    
    var textType: TextType {
        get {
            if keyboardType == .emailAddress {
                return .emailAddress
            } else if isSecureTextEntry {
                return .password
            }
            return .generic
        }
        set {
            switch newValue {
            case .emailAddress:
                keyboardType = .emailAddress
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = false
                
            case .password:
                keyboardType = .asciiCapable
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = true
                
            case .generic:
                isSecureTextEntry = false
            }
        }
    }
    
    var placeholder: String? {
        get {
            attributedPlaceholder?.string
        }
        
        set {
            guard let newValue = newValue else {
                attributedPlaceholder = nil
                return
            }
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray]
            let attributedText = NSAttributedString(string: newValue, attributes: attributes)
            attributedPlaceholder = attributedText
            
        }
    }
    
    var hasValidEmail: Bool {
        
        return text!.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                           options: String.CompareOptions.regularExpression,
                           range: nil, locale: nil) != nil
    }
    
    var leftViewTintColor: UIColor? {
        get {
            guard let iconView = leftView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = leftView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }
    
    func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 18 + padding, height: 18))
        let imageView = UIImageView(image: image)
        imageView.frame = iconView.bounds
        imageView.contentMode = .scaleAspectFit
        iconView.addSubview(imageView)
        leftView = iconView
        leftViewMode = .always
    }
}

extension UIButton {
    
    func centerTextAndImage(imageAboveText: Bool = false, spacing: CGFloat) {
        if imageAboveText {
            
            guard
                let imageSize = imageView?.image?.size,
                let text = titleLabel?.text,
                let font = titleLabel?.font else { return }
            
            let titleSize = text.size(withAttributes: [.font: font])
            
            let titleOffset = -(imageSize.height + spacing)
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: titleOffset, right: 0.0)
            
            let imageOffset = -(titleSize.height + spacing)
            imageEdgeInsets = UIEdgeInsets(top: imageOffset, left: 0.0, bottom: 0.0, right: -titleSize.width)
            
            let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
            contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
        } else {
            let insetAmount = spacing / 2
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
    
}

// MARK: - UIViewController
extension UIViewController {
    
    @available(iOS 13, *)
    private struct Preview: UIViewControllerRepresentable {
        
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
    
    @available(iOS 13, *)
    func showPreview() -> some View {
        Preview(viewController: self)
    }
    
    func addChild(this child: UIViewController, contentView:UIView ) {
        addChild(child)
        contentView.addSubview(child.view)
        
        UIView.transition(with: contentView, duration: 0.5, options: .curveLinear, animations: {
            child.didMove(toParent: self)
        }, completion: nil)
        
        
    }
    
    func removeChildFromParent() {
        
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    
    //    func playLoading(){
    //        let view = BLLoadingIndicator()
    //        view.addLoading(to: self)
    //        self.view.bringSubviewToFront(view)
    //    }
    //
    //    func stopLoading(){
    //        self.view.subviews.forEach({ view in
    //            guard let loading = view as? BLLoadingIndicator else { return }
    //            loading.removeFromSuperview()
    //        })
    //    }
    
}

// MARK: - String
extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    func maskToPhoneNumber() -> String {
        let isMoreThanTenDigit = self.count > 10
        _ = self.startIndex
        var newstr = ""
        if isMoreThanTenDigit {
            newstr = "\(self.dropFirst(self.count - 10))"
        }
        else if self.count == 10{
            newstr = "\(self)"
        }
        else {
            return "number has only \(self.count) digits"
        }
        
        if  newstr.count == 10 {
            let internationalString = "\(newstr.dropLast(7)) \(newstr.dropLast(4).dropFirst(3)) \(newstr.dropFirst(6).dropLast(2)) \(newstr.dropFirst(8))"
            newstr = internationalString
        }
        
        return newstr
    }
    
    /// It formats a String Value to Date easily.
    /// - Parameter formatType: If method is called without parameters, it formats string with standard format style(dd.MM.yyyy). If you want to define another format you can it.
    /// .standard = dd.MM.yyyy -> 28.02.2020
    /// .longDate = yyyy-MM-dd'T'HH:mm:ss.SSSZ -> 2021-01-28 14:00:00.000
    /// .withoutYear = "dd MMMM" -> 27 April
    /// .dateAndTime = "dd.MM.yyyy'T'HH:mm" 27.01.2021 14:00
    /// - Returns: Method returns formatted date from String that define by user.
    func formatToDate(formatType: FormatType = .localeStandard)-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "tr")
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = formatType.rawValue
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
    
    func formatDate() -> String? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = dateFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "tr_TR")
            outputFormatter.dateFormat = "dd MMMM yyyy" // Türkçe tarih formatını ayarlayın
            let formattedDateString = outputFormatter.string(from: date)
            return formattedDateString
        }
        
        return nil
    }
    
    func extractCityName() -> String {
            let components = self.components(separatedBy: ",")
            if components.count > 1 {
                let secondComponent = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                if !secondComponent.isEmpty {
                    return secondComponent
                }
            }
            return self
    }
    
    
    func extractDate() -> String? {
        let endIndex = self.index(self.startIndex, offsetBy: 10)
        return String(self.prefix(upTo: endIndex))
    }
       
    
}

// MARK: - User Defaults
extension UserDefaults {
    
    enum Keys: String, CaseIterable {
        case tokenObject
        case currentUser
    }
    
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
    
    func setEncodedObject<T:Codable>(object:T,key:Keys) {
        
        if let encoded = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getEncodedObject<T:Codable>(key:Keys, object:T.Type) -> T?{
        if let data = UserDefaults.standard.data(forKey: key.rawValue), let dataObject = try? JSONDecoder().decode(object, from: data) {
            return dataObject
        }
        return nil
    }
}

// MARK: - UIDatePicker
extension UIDatePicker {
    
    public var roundedDate: Date {
        let referenceTimeInterval = self.date.timeIntervalSinceReferenceDate
        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(minuteInterval*60))
        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
        return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
    }
}

// MARK: - Date
extension Date {
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month], from: self)
        components.hour = 3
        return  calendar.date(from: components)!
    }
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    
    func formatToString(formatType:FormatType = .localeStandard)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatType.rawValue
        formatter.locale = Locale(identifier: "tr")
        return formatter.string(from: self)
    }
}

// MARK: - Optional
extension Optional {
    
    func ifNil(_ default:Wrapped) -> Wrapped {
        return self ?? `default`
    }
}

// MARK: - Array
extension Array {
    
    public subscript(safe index: Int) -> Element? {
        guard startIndex <= index && index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}

extension UIImageView{
    func animateImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.transition(with: self, duration: duration, options: .curveEaseIn, animations: {
            self.image = image
        }, completion: nil)
    }
}

// MARK: -UIImage
extension UIImage {
    
    class func colorToImage(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 2.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

// MARK: - UITabBar
extension UITabBar {
    //    override open func sizeThatFits(_ size: CGSize) -> CGSize {
    //        super.sizeThatFits(size)
    //        var sizeThatFits = super.sizeThatFits(size)
    //        sizeThatFits.height = 78
    //        return sizeThatFits
    //    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
