//
//  TypesCollectionViewCell.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 25.03.2023.
//

import UIKit

protocol TypesCollectionViewCellDelegate: AnyObject {
    func pokeTapped(id: Int)
}

extension TypesCollectionViewCellDelegate {
    func pokeTapped(id: Int) {}
}

class TypesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var types = [TypeElement]()
    weak var delegate: TypesCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        headerLabel.text = "Types"
        headerLabel.textColor = .darkGray
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView.register(cellType: PokemonImageCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setData(types: [TypeElement], delegate: TypesCollectionViewCellDelegate) {
        self.types = types
        self.delegate = delegate
        self.collectionView.reloadData()
    }

}

// MARK: - CollectionView Delegate and DataSource
extension TypesCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.types[indexPath.item]
        let cell = collectionView.dequeueReusableCell(with: PokemonImageCell.self, for: indexPath)
        cell.setData(id: item.type.id, radius: 14, bgColor: .lightBlue.withAlphaComponent(0.3))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.height
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = self.types[indexPath.item].type.id
        delegate?.pokeTapped(id: id)
    }
}
