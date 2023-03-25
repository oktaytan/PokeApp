//
//  BaseCollectionViewProvider.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import Foundation

// CollectionView Provider protocol tanımı
protocol CollectionViewProvider {
    associatedtype T
    associatedtype I
    
    var dataList: [T]? { get set }
    func setupCollectionLayout()
    func didSelectItem(indexPath: I)
}


extension CollectionViewProvider {
    func setupCollectionLayout() {}
    func didSelectItem(indexPath: I) {}
}
