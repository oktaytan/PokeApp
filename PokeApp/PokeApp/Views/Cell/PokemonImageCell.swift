//
//  PokemonImageCell.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import UIKit
import Kingfisher

final class PokemonImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        imageView.contentMode = .scaleAspectFit
    }

    func setData(id: Int, radius: CGFloat = 0.0, bgColor: UIColor = .clear) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.cornerRadius = radius
            self?.imageView.backgroundColor = bgColor
            
            let urlString = AppConstants.PokeImageURL + "/\(id).png"
            let placeholder = UIImage(named:"pokeball-icon")
            let processor = DownsamplingImageProcessor(size: self?.imageView.bounds.size ?? .zero)
                         |> RoundCornerImageProcessor(cornerRadius: 0)
            self?.imageView.kf.indicatorType = .activity
            if let url = URL(string: urlString) {
                self?.imageView.kf.setImage(
                    with: url,
                    placeholder: placeholder,
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.5)),
                        .cacheOriginalImage
                    ])
            } else {
                self?.imageView.image = UIImage(named: "pokeball-icon")
            }
        }
    }
}
