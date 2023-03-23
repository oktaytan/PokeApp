//
//  PokeDetailBuilder.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

protocol PokeDetailBuilder {
    static func build(pokeID: String, coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController
}

struct PokeDetailBuilderImpl: PokeDetailBuilder {
    static func build(pokeID: String, coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController {
        let vc = PokeDetailVC(nibName: PokeDetailVC.className, bundle: nil)
        vc.coordinatorDelegate = coordinatorDelegate
        
        return vc
    }
}
