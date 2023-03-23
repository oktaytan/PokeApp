//
//  PokeListVC.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

class PokeListVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        self.title = AppConstants.AppTitle
    }
    
    @IBAction func goToPokeDetail(_ sender: Any) {
        
        APIHandler.shared.processRequest(target: Endpoint.detail(id: 2)).done { (response: PokemonDetail) in
            print(response)
        }.catch { error in
            print(error)
        }
    }
}
