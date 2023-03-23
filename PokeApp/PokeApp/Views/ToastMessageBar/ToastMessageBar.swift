//
//  ToastMessageBar.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

class ToastMessageBar: BaseCustomView {
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var topSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    func setup(title: String?, message: String) {
        if title == "" || title == nil {
            titleLabel.isHidden = true
            titleLabel.text = nil
        } else {
            titleLabel.text = title
            titleLabel.isHidden = false
        }
        
        messageLabel.text = message
        titleLabel.sizeToFit()
        messageLabel.sizeToFit()
        
        contentView.cornerRadius = 14
        contentView.backgroundColor = setBackgroundColor
    }
    
    var setTopConstraint: CGFloat = 0 {
        didSet {
            topSafeAreaConstraint.constant = setTopConstraint
        }
    }
    
    var setBackgroundColor: UIColor = .red {
        didSet {
            contentView.backgroundColor = setBackgroundColor
        }
    }
    
    var setIcon: String? {
        didSet {
            guard let setIcon = setIcon else { return }
            iconImageView.image = UIImage(named: setIcon)
        }
    }
}
