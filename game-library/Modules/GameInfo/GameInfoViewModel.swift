//
//  GameInfoViewModel.swift
//  game-library
//
//  Created by Sezer Istif on 23.01.2023.
//

import Foundation

class GameInfoViewModel {
    let model = GameInfoModel()
    var setComments: (([Comment]) -> ())?
    
    init() {
        model.delegate = self
    }
    
    func fetchComments(gameID: Int) {
        model.fetchCommentsFromCoreData(gameID: gameID)
    }
    
    func addComment(text: String, gameID: Int) {
        model.saveCommentToCoreData(header: "Header", text: text, gameID: gameID)
    }
}

extension GameInfoViewModel: GameInfoModelDelegate {
    func commentsFetched(comments: [Comment]) {
        self.setComments?(comments)
    }
    
}
