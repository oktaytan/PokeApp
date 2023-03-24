//
//  PokemonNameCell.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import UIKit

final class PokemonNameCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        nameLabel.textColor = .closeRed
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }

    func setData(name: String) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLabel.text = "♦️  \(name)  ♦️".uppercased()
        }
    }
}
