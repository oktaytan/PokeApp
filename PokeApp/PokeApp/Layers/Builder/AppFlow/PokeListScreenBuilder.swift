//
//  PokeListScreenBuilder.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

protocol PokeListScreenBuilder {
    static func build(coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController
}

struct PokeListScreenBuilderImpl: PokeListScreenBuilder {
    static func build(coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController {
        let vc = PokeListVC(nibName: PokeListVC.className, bundle: nil)
        vc.coordinatorDelegate = coordinatorDelegate
        return vc
    }
}
