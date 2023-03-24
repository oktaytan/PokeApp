//
//  AbilityNameCell.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import UIKit

final class AbilityNameCell: UITableViewCell {

    @IBOutlet weak var abilityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        abilityLabel.textColor = .darkGray
        abilityLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    func setData(name: String) {
        DispatchQueue.main.async { [weak self] in
            self?.abilityLabel.text = name
        }
    }
}
