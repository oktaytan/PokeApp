//
//  ToastMessage.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit


enum ToastMessageType: String {
    
    case error, success, info, warning
    
    var bgColor: UIColor {
        switch self {
        case .error:
            return UIColor.closeRed
        case .success:
            return UIColor.darkGreen
        case .info:
            return UIColor.sunYellow
        case .warning:
            return UIColor.carrotOrange
        }
    }
    
    var icon: String {
        return "\(self.rawValue)-icon"
    }
}

enum ToastMessageStatus {
    case willOpen, didOpen, willClose, didClose
}


class ToastMessage {
    
    static let shared = ToastMessage()
    
    private(set) var toastBar = ToastMessageBar()
    private(set) var topFrameCalc: CGRect = .zero
    private(set) var timer: Timer?
    private(set) var isOpen: Bool = false
    var stateCompletion: ((_ state: ToastMessageStatus) -> ())?
    
    private func showAlert(window: UIWindow, title: String?, message: String, type: ToastMessageType = .info, delay: TimeInterval = 3.0, completion: ((_ state: ToastMessageStatus) -> ())?) {
        
        self.stateCompletion = completion
        
        toastBar.setup(title: title, message: message)
        toastBar.setTopConstraint = window.safeAreaInsets.top
        toastBar.frame = CGRect(x: 0, y: 0, width: AppDesign.ScreenWidth, height: window.safeAreaInsets.top + 70)
        
        toastBar.setBackgroundColor = type.bgColor
        toastBar.setIcon = type.icon
        toastBar.layer.zPosition = 999
        
        topFrameCalc = toastBar.frame
        topFrameCalc.origin.y -= toastBar.frame.size.height
        toastBar.frame = topFrameCalc
        toastBar.alpha = 0
        
        toastBar.closeBtn.addTarget(self, action: #selector(closeWithButton), for: .touchUpInside)
        
        removeToastMessages(owner: nil, completion: completion)
        window.addSubview(toastBar)
        
        if !isOpen {
            completion?(.willOpen)
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.10, options: .curveEaseOut) { [weak self] in
                self?.toastBar.frame.origin.y = 0
                self?.toastBar.alpha = 1
            } completion: { [weak self] _ in
                guard let self = self else { return }
                completion?(.didOpen)
                self.isOpen = true
                self.timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(self.handleClose), userInfo: nil, repeats: false)
            }
        }
    }
    
    /// Uyarı barını mevcut window' a subview olarak ekleyerek gösterir.
    /// - Parameters:
    ///   - title: Uyarı başlığıdır. (Optional)
    ///   - message: Uyarı mesajıdır.
    ///   - type: Uyarının tipini belirtir. - default = info
    ///   - delay: Uyarının kaç saniye sonra kapanacağını belirtir. - default = 3 sn
    ///   - completion: Uyarı barının görüntülenme durumunu döner.
    func showOnWindow(window: UIWindow = AppDesign.Window ?? UIWindow(), title: String?, message: String, type: ToastMessageType = .info, delay: TimeInterval = 3.0, completion: ((_ state: ToastMessageStatus) -> ())? = nil) {
        showAlert(window: window, title: title, message: message, type: type, delay: delay, completion: completion)
    }
}

extension ToastMessage {
    private func closeAnimation(delay: TimeInterval = 0) {
        if isOpen {
            stateCompletion?(.willClose)
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.10, options: .curveEaseIn) { [weak self] in
                self?.toastBar.frame = self?.topFrameCalc ?? .zero
                self?.toastBar.alpha = 0
            } completion: { [weak self] _ in
                self?.toastBar.removeFromSuperview()
                self?.timer?.invalidate()
                self?.timer = nil
                self?.stateCompletion?(.didClose)
                self?.stateCompletion = nil
                self?.isOpen = false
            }
        }
    }
    
    @objc func handleClose(timer: Timer) {
        closeAnimation()
    }
    
    @objc func closeWithButton(sender: UIButton) {
        closeAnimation()
    }
    
    func removeToastMessages(owner: UIViewController? = nil, completion: ((_ state: ToastMessageStatus) -> ())? = nil) {
        if isOpen {
            completion?(.willClose)
            if let window = AppDesign.Window {
                window.subviews.forEach { view in
                    if view is ToastMessageBar {
                        view.removeFromSuperview()
                        timer?.invalidate()
                        timer = nil
                        completion?(.didClose)
                        self.isOpen = false
                    }
                }
            }
            
            if let owner = owner {
                owner.view.subviews.forEach { view in
                    if view is ToastMessageBar {
                        view.removeFromSuperview()
                        timer?.invalidate()
                        timer = nil
                        completion?(.didClose)
                        self.isOpen = false
                    }
                }
            }
        }
    }
}
