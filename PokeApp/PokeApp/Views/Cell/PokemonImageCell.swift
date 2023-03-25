//
//  PokemonImageCell.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import UIKit

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
            self?.imageView.loadImage(urlString: urlString)
        }
    }
}
