//
//  UIImageView+Ext.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 25.03.2023.
//

import UIKit
import Kingfisher

public extension UIImageView {
    func loadImage(urlString: String, radius: CGFloat = 0, transition: ImageTransition = .fade(0.5)) {
        let placeholder = UIImage(named:"pokeball-icon")
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: radius)
        
        self.kf.indicatorType = .activity
        
        if let url = URL(string: urlString) {
            self.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(transition),
                    .cacheOriginalImage
                ])
        } else {
            self.image = UIImage(named: "pokeball-icon")
        }
    }
}
