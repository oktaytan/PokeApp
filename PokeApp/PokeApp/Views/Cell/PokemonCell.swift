//
//  PokemonCell.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import UIKit
import Kingfisher

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
            let placeholder = UIImage(named:"pokeball-icon")
            let processor = DownsamplingImageProcessor(size: self?.photoView.bounds.size ?? .zero)
                         |> RoundCornerImageProcessor(cornerRadius: 10)
            self?.photoView.kf.indicatorType = .activity
            if let url = URL(string: urlString) {
                self?.photoView.kf.setImage(
                    with: url,
                    placeholder: placeholder,
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.5)),
                        .cacheOriginalImage
                    ])
            } else {
                self?.photoView.image = UIImage(named: "pokeball-icon")
            }
        }
    }
}
