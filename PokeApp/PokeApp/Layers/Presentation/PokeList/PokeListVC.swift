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
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func goToPokeDetail(_ sender: Any) {
        self.coordinatorDelegate?.commonControllerToCoordinator(eventType: .pokeDetail(id: "2"))
    }
}
