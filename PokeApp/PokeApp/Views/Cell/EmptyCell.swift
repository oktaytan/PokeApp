//
//  EmptyCell.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import UIKit

class EmptyCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        messageLabel.text = "Not found!"
        messageLabel.textColor = .closeRed
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
}
