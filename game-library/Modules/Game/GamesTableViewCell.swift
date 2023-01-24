//
//  GamesTableViewCell.swift
//  game-library
//
//  Created by Sezer Istif on 15.01.2023.
//

import UIKit
import Kingfisher
import CoreData

class GamesTableViewCell: UITableViewCell {
    var cellIndex: Int?
    var game: Game?
    var viewModel: GamesTableViewCellViewModel?
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.masksToBounds = true
        imageContent.layer.cornerRadius = 10.0
    }
    
    func configure(with model: Game, favorites: [Int]) {
        imageContent.kf.setImage(with: URL.init(string: model.imageURL))
        nameLabel.text = model.name
        ratingLabel.text = String(format: "%0.0f", model.rating)
        game = model
        
        if (favorites.contains(model.id)) {
            button.isSelected = true
        } else {
            button.isSelected = false
        }
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if let game {
            if (button.isSelected) {
                viewModel?.unFavorite(id: game.id)
            } else {
                viewModel?.favorite(game: game)
            }
            
        }
    }
}

private extension GamesTableViewCell {
    private func setupUI() {
        viewContainer.layer.cornerRadius = 10.0
    }
}

protocol GamesTableViewCellViewModel {
    func favorite(game: Game)
    func unFavorite(id: Int)
    
}


