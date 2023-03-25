//
//  PokemonCell.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import UIKit

final class PokemonCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        containerView.backgroundColor = .white
        containerView.configureShadow(shadowColor: .lightGray, offset: CGSize(width: 2, height: 2), shadowRadius: 8, shadowOpacity: 0.25, cornerRadius: 10)
        photoView.contentMode = .scaleAspectFit
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        nameLabel.textColor = .closeRed
    }
    
    func setData(item: Pokemon) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLabel.text = item.name.uppercased()
            
            let urlString = AppConstants.PokeImageURL + "/\(item.id).png"
            self?.photoView.loadImage(urlString: urlString, radius: 10)
        }
    }
}
