//
//  TriviaController.swift
//  Trivia
//
//  Created by Fried on 10/12/2018.
//  Copyright © 2018 Fried. All rights reserved.
//

import Foundation
import UIKit
import HTMLString

class TriviaController {
    static let shared = TriviaController()
    
    
    
    func getData(amount: Int, category: Int, difficulty: String, type: String, completion: @escaping ([Question]?) -> Void) {
        let url = URL(string: "https://opentdb.com/api.php?amount=\(amount)&category=\(category)&difficulty=\(difficulty)&type=\(type)")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let trivia = try? JSONDecoder().decode(TriviaQuestions.self, from: data) {
                completion(trivia.results)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func getHighscores(completion: @escaping ([Player]?) -> Void) {
        let url = URL(string: "https://ide50-fried-scholvinck.cs50.io:8080/list")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    
                    let highScores = try JSONDecoder().decode([Player].self, from: data)
                    completion(highScores)
                } else {
                    completion(nil)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}
