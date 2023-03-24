//
//  BaseTableViewProvider.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import Foundation

/// TableView Provider protocol tanımı
protocol TableViewProvider {
    associatedtype T
    associatedtype I
    
    var dataList: [T]? { get set }
    func didSelectItem(indexPath: I)
}


extension TableViewProvider {
    func didSelectItem(indexPath: I) {}
}
