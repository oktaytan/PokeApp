//
//  PokeTableViewProvider.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import UIKit

protocol PokeTableViewProvider {
    var fechingMore: Bool { get set }
    
    var tableViewStateClosure: ((ObservationType<PokeTableViewImpl.TableViewUserInteractivity, Error>) -> ())? { get set }
    func setData(data: [PokeListViewModelImpl.RowType]?)
    func tableViewReload()
    func setupTableView(tableView: UITableView)
}


final class PokeTableViewImpl: NSObject, TableViewProvider, PokeTableViewProvider {
    
    typealias T = PokeListViewModelImpl.RowType
    typealias I = IndexPath
    
    var dataList: [T]?
    var fechingMore: Bool = false
    var tableViewStateClosure: ((ObservationType<TableViewUserInteractivity, Error>) -> ())?
    
    private var tableView: UITableView?
    
    func setData(data: [T]?) {
        self.dataList = data
        tableViewReload()
    }
    
    func tableViewReload() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
    func setupTableView(tableView: UITableView) {
        self.tableView = tableView
        let cells = [PokemonCell.self, EmptyCell.self]
        self.tableView?.register(cellTypes: cells)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.prefetchDataSource = self
        self.tableView?.separatorStyle = .none
        self.tableView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 52, right: 0)
    }
}

extension PokeTableViewImpl {
    enum TableViewUserInteractivity {
        case didSelectPokemon(id: Int), fetchMore
    }
}

extension PokeTableViewImpl: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowType = dataList?[indexPath.row] else { return UITableViewCell() }
        switch rowType {
        case .pokemon(let data):
            let cell = tableView.dequeueReusableCell(with: PokemonCell.self, for: indexPath)
            cell.setData(item: data)
            return cell
        case .empty:
            let cell = tableView.dequeueReusableCell(with: EmptyCell.self, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let rowType = dataList?[indexPath.row] else { return 0.0 }
        switch rowType {
        case .pokemon:
            return 100.0
        case .empty:
            return tableView.frame.size.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rowType = dataList?[indexPath.row] else { return }
        switch rowType {
        case .pokemon(let data):
            tableViewStateClosure?(.updateUI(data: .didSelectPokemon(id: data.id)))
        default:
            break
        }
    }
}


extension PokeTableViewImpl: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row == (self.dataList?.count ?? 0) - 1 {
                self.tableViewStateClosure?(.updateUI(data: .fetchMore))
            }
        }
    }
}
