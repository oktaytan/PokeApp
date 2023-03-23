//
//  PokeDetailVC.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

class PokeDetailVC: BaseViewController {
    
    var isLiked: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        self.setupNavBar(title: nil, leftIcon: "left-arrow-icon", rightIcon: isLiked ? "heart-fill-icon" : "heart-icon", leftItemAction: #selector(goToList), rightItemAction: #selector(like))
    }
    
    @objc func goToList() {
        self.goBack()
    }
    
    @objc func like() {
        isLiked = !isLiked
        self.setupNavBar(title: nil, leftIcon: nil, rightIcon: isLiked ? "heart-fill-icon" : "heart-icon", rightItemAction: #selector(like))
    }
}
