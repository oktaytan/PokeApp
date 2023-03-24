//
//  PokeDetailCollectionViewProvider.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import UIKit

protocol PokeDetailCollectionViewProvider {
    
    var collectionViewStateClosure: ((ObservationType<PokeDetailCollectionViewProviderImpl.CollectionViewUserInteractivity, Error>) -> ())? { get set }
    func setData(data: [PokeDetailViewModelImpl.SectionType]?)
    func collectionViewReload()
    func setupCollectionView(collectionView: UICollectionView)
}


final class PokeDetailCollectionViewProviderImpl: NSObject, CollectionViewProvider, PokeDetailCollectionViewProvider {
    
    typealias T = PokeDetailViewModelImpl.SectionType
    typealias I = IndexPath
    
    var dataList: [T]?
    var collectionViewStateClosure: ((ObservationType<CollectionViewUserInteractivity, Error>) -> ())?
    
    private var collectionView: UICollectionView?
    
    func setData(data: [T]?) {
        self.dataList = data
        collectionViewReload()
    }
    
    func collectionViewReload() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
        }
    }
    
    func setupCollectionView(collectionView: UICollectionView) {
        self.collectionView = collectionView
        setupCollectionLayout()
        let cells = [PokemonImageCell.self,
                     PokemonNameCell.self,
                     AbilityCollectionViewCell.self,
                     TypesCollectionViewCell.self]
        self.collectionView?.register(cellTypes: cells)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
    }
    
    func setupCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}

extension PokeDetailCollectionViewProviderImpl {
    enum CollectionViewUserInteractivity {
        case goToPokemon(id: Int), showEffect(effect: EffectEntry)
    }
}

extension PokeDetailCollectionViewProviderImpl: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = self.dataList?[section] as? T else { return 0 }
        switch sectionType {
        case .pokemon(let rows): return rows.count
        case .ability, .types: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = self.dataList?[indexPath.section] as? T else { return UICollectionViewCell() }
        switch sectionType {
        case .pokemon(let rows): return getCellForItem(at: indexPath, rows: rows, collectionView: collectionView)
        case .ability(let data):
            let cell = collectionView.dequeueReusableCell(with: AbilityCollectionViewCell.self, for: indexPath)
            cell.setData(abilities: data, delegate: self)
            return cell
        case .types(let data):
            let cell = collectionView.dequeueReusableCell(with: TypesCollectionViewCell.self, for: indexPath)
            cell.setData(types: data, delegate: self)
            return cell
        }
    }
    
    private func getCellForItem(at indexPath: IndexPath, rows: [PokeDetailViewModelImpl.RowType], collectionView: UICollectionView) -> UICollectionViewCell {
        let rowType = rows[indexPath.item]
        switch rowType {
        case .image(let id):
            let cell = collectionView.dequeueReusableCell(with: PokemonImageCell.self, for: indexPath)
            cell.setData(id: id, radius: 0.0, bgColor: .closeRed)
            return cell
        case .name(let name):
            let cell = collectionView.dequeueReusableCell(with: PokemonNameCell.self, for: indexPath)
            cell.setData(name: name)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let sectionType = self.dataList?[indexPath.section] as? T else { return .zero }
        let width = collectionView.bounds.width
        switch sectionType {
        case .pokemon(let rows): return getCellSizeForItem(at: indexPath, rows: rows, collectionView: collectionView)
        case .ability(let data):
            return CGSize(width: width, height: Double((data.count * 52) + 50))
        case .types:
            return CGSize(width: width, height: 152)
        }
    }
    
    private func getCellSizeForItem(at indexPath: IndexPath, rows: [PokeDetailViewModelImpl.RowType], collectionView: UICollectionView) -> CGSize {
        let rowType = rows[indexPath.item]
        let width = collectionView.bounds.width
        switch rowType {
        case .image:
            return CGSize(width: width, height: width / 2)
        case .name:
            return CGSize(width: collectionView.bounds.width, height: 80)
        }
    }
}


extension PokeDetailCollectionViewProviderImpl: AbilityCollectionViewCellDelegate {
    func showEffect(effect: EffectEntry) {
        self.collectionViewStateClosure?(.updateUI(data: .showEffect(effect: effect)))
    }
}


extension PokeDetailCollectionViewProviderImpl: TypesCollectionViewCellDelegate {
    func pokeTapped(id: Int) {
        self.collectionViewStateClosure?(.updateUI(data: .goToPokemon(id: id)))
    }
}
