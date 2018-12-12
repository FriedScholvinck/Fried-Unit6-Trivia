
//
//  ResultViewController.swift
//  Trivia
//
//  Created by Fried on 11/12/2018.
//  Copyright © 2018 Fried. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var questions: [Question] = []
    var answersCorrect = 0
    var highScores: [Player] = []
    
    let easyMultiplier: Float = 1.0
    let mediumMultiplier: Float = 1.2
    let hardMultiplier: Float = 1.4
    
    @IBOutlet weak var highScoreTable: UITableView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        showHighscores()
        submitButton.applyDesign()

        let category = questions[0].category
        let difficulty = questions[0].difficulty
        let type = questions[0].type

        resultLabel.text = "You've answered \(answersCorrect) of \(questions.count) \(difficulty) \(type) questions correctly in the category \(category)!"
        scoreLabel.text = String(calculateScore(difficulty: difficulty))
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        highScoreTable.reloadData()
//    }
    
    func calculateScore(difficulty: String) -> Int {
        let subScore = Float(answersCorrect) / Float(questions.count) * Float(questions.count + 100)
        if difficulty == "easy" {
            return Int(subScore * easyMultiplier)
        }
        else if difficulty == "medium" {
            return Int(subScore * mediumMultiplier)
        }
        else {
            return Int(subScore * hardMultiplier)
        }
    }
    
    func showHighscores() {
        TriviaController.shared.getHighscores() { (highScores) in
            if let highScores = highScores {
                self.highScores = highScores.sorted(by: >)
            }
            DispatchQueue.main.async {
                self.highScoreTable.reloadData()
            }
            
        }
    }
    
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        submitButton.isEnabled = false
        submitButton.backgroundColor = UIColor.lightGray
        let url = URL(string: "https://ide50-fried-scholvinck.cs50.io:8080/list")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "name=\(usernameTextfield.text!)&score=\(scoreLabel.text!)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.showHighscores()
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
//        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }
    
    /// set cell text and image
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let player = highScores[indexPath.row]
        cell.textLabel?.text = player.name
        cell.detailTextLabel?.text = player.score
    }
    
}
