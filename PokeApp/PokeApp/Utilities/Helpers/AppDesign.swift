//
//  AppDesign.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

// MARK: Design constants
struct AppDesign {
    
    static var SafeAreaTop: CGFloat {
        return Window?.safeAreaInsets.top ?? 0
    }
    
    static var SafeAreaBottom: CGFloat {
        return Window?.safeAreaInsets.bottom ?? 0
    }
    
    static var Window: UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            window = (UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first)
        } else {
            window = UIApplication.shared.keyWindow
        }
        return window
    }
    
    static let ScreenWidth: CGFloat = UIScreen.main.bounds.width
    static let ScreenHeight: CGFloat = UIScreen.main.bounds.height
}
