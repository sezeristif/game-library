//
//  CommentCellTableViewCell.swift
//  game-library
//
//  Created by Sezer Istif on 23.01.2023.
//

import UIKit

class CommentCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(text: String) {
        commentLabel?.text = text
    }
    
}
