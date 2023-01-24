//
//  ViewController.swift
//  game-library
//
//  Created by Sezer Istif on 15.01.2023.
//

import UIKit
import DropDown

class GamesViewController: UIViewController {
    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dropdownButton: UIButton!
    
    private let gamesViewModel = GamesViewModel()
    private var gamesTableViewHelper: GamesTableViewHelper!
    private var lastSearchTxt = ""
    private var currentPage = 1
    var dropdown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        gamesViewModel.didViewLoad()
        
    }
    
    @IBAction func dropdownButtonPressed(_ sender: Any) {
        dropdown.show()
    }
}

private extension GamesViewController {
    private func setupUI() {
        self.hideKeyboardWhenTappedAround()
        gamesTableViewHelper = .init(tableView: gamesTableView, viewModel: gamesViewModel)
        searchBar.backgroundImage = UIImage()
        dropdown.anchorView = dropdownButton
        dropdown.dataSource = ["All", "Action", "Indie"]
        dropdown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.gamesViewModel.fetchData(searchText: self?.searchBar?.text ?? "", page: 1, genres: item == "All" ? nil : item.lowercased())
        }
    }
    
    func setupBindings() {
        gamesViewModel.onError = { [weak self] message in
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alertController.addAction(.init(title: "Ok", style: .default))
            self?.present(alertController, animated: true)
        }
        
        gamesViewModel.refreshItems = { [weak self] items in
            self?.gamesTableViewHelper.setItems(items)
        }
        
        gamesViewModel.setFavorites = { [weak self] favorites in
            self?.gamesTableViewHelper.setFavorites(favorites)
        }
        
        gamesTableViewHelper.fetchNextPage = {
            self.currentPage = self.currentPage + 1
            self.gamesViewModel.fetchData(searchText: self.lastSearchTxt, page: self.currentPage)
        }
        
        gamesTableViewHelper.cellPressed = { [weak self] game in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "GameInfoViewController") as! GameInfoViewController
            controller.game = game
            self?.present(controller, animated: true, completion: nil)
        }
    }
}

extension GamesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if lastSearchTxt.isEmpty {
            lastSearchTxt = searchText
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.makeNetworkCall), object: lastSearchTxt)
        lastSearchTxt = searchText
        self.perform(#selector(self.makeNetworkCall), with: searchText, afterDelay: 0.3)
    }
    
    @objc private func makeNetworkCall(sender: String) {
        gamesViewModel.fetchData(searchText: sender, page: 1)
    }
}







