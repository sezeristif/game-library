//
//  GamesTableViewHelper.swift
//  game-library
//
//  Created by Sezer Istif on 15.01.2023.
//

import UIKit

class GamesTableViewHelper: NSObject {
    
    typealias RowItem = Game
    
    private let cellIdentifier = "GamesTableViewCell"
    private var tableView: UITableView?
    private weak var viewModel: GamesViewModel?
    
    var fetchNextPage: (() -> ())?
    var cellPressed: ((Game) -> ())?
    private var items: [RowItem] = []
    private var favorites: [Int] = []
    
    init(tableView: UITableView, viewModel: GamesViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView?.register(.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = .systemGray3
    }
    
    func setItems(_ items: [RowItem]) {
        self.items = items
        tableView?.reloadData()
    }
    
    func setFavorites(_ favorites: [Game]) {
        self.favorites = favorites.map{ $0.id }
        tableView?.reloadData()
    }
}

extension GamesTableViewHelper: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameCellModel = items[indexPath.row]
        cellPressed?(gameCellModel)
    }
}

extension GamesTableViewHelper: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! GamesTableViewCell
        cell.configure(with: items[indexPath.row], favorites: favorites)
        cell.viewModel = viewModel
        
        if (items.count - 1 == indexPath.row) {
            fetchNextPage?()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView()
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

