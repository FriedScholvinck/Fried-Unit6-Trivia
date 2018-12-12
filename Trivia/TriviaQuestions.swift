//
//  TriviaQuestions.swift
//  Trivia
//
//  Created by Fried on 10/12/2018.
//  Copyright © 2018 Fried. All rights reserved.
//

import Foundation

struct TriviaQuestions: Decodable {
    var response_code: Int
    var results: [Question]
}

struct Question: Decodable {
    var category: String
    var type: String
    var difficulty: String
    var question: String
    var correct_answer: String
    var incorrect_answers: [String]
}

struct Player: Decodable, Comparable {
    var name: String
    var score: String
    
    static func < (lhs: Player, rhs: Player) -> Bool {
        return Int(lhs.score)! < Int(rhs.score)!
    }
}
