//
//  GameInfoViewController.swift
//  game-library
//
//  Created by Sezer Istif on 23.01.2023.
//

import UIKit
import Kingfisher

class GameInfoViewController: UIViewController {
    var game: Game?
    let viewModel = GameInfoViewModel()
    var comments: [Comment] = []
    
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        setupBindings()
        setupKeyboardMove()
        viewModel.fetchComments(gameID: game?.id ?? 0)
    }
    
    
    @IBAction func addCommentPressed(_ sender: Any) {
        let text = commentField.text
        if (text!.count > 0) {
            viewModel.addComment(text: text!, gameID: game!.id)
            commentField.text = ""
        } else {
            let alertController = UIAlertController(title: "Failure", message: "Comment Should be Present", preferredStyle: .alert)
            alertController.addAction(.init(title: "Ok", style: .default))
            self.present(alertController, animated: true)
            
        }
    }
}

private extension GameInfoViewController {
    private func setupUI() {
        image.kf.setImage(with: URL.init(string: game?.imageURL ?? ""))
        nameLabel.text = game?.name
        ratingLabel.text = String(format: "%0.0f", game?.rating ?? 0)
    }
    
    private func setupBindings() {
        viewModel.setComments = { [weak self] comments in
            self?.comments = comments
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.register(.init(nibName: "CommentCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCellTableViewCell")
        tableView.dataSource = self
    }
    
    private func setupKeyboardMove() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension GameInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCellTableViewCell") as! CommentCellTableViewCell
        let text = comments[indexPath.row].text
        cell.configure(text: text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


