//
//  AbilityCollectionViewCell.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import UIKit

protocol AbilityCollectionViewCellDelegate: AnyObject {
    func showEffect(effect: EffectEntry)
}

extension AbilityCollectionViewCellDelegate {
    func showEffect(effect: EffectEntry) {}
}

final class AbilityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var abilites = [AbilityDetail]()
    weak var delegate: AbilityCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        headerLabel.text = "Abilities"
        headerLabel.textColor = .darkGray
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        tableView.register(cellType: AbilityNameCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setData(abilities: [AbilityDetail], delegate: AbilityCollectionViewCellDelegate) {
        self.abilites = abilities
        self.delegate = delegate
        self.tableView.reloadData()
    }
}


// MARK: - TableView Delegate and DataSource
extension AbilityCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ability = self.abilites[indexPath.row]
        let cell = tableView.dequeueReusableCell(with: AbilityNameCell.self, for: indexPath)
        cell.setData(name: ability.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let effect = self.abilites[indexPath.row].effectEntries.first!
        delegate?.showEffect(effect: effect)
    }
}
