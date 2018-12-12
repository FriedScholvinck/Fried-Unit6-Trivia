//
//  QuestionViewController.swift
//  Trivia
//
//  Created by Fried on 11/12/2018.
//  Copyright © 2018 Fried. All rights reserved.
//

import UIKit
import HTMLString

class QuestionViewController: UIViewController {
    var questions: [Question] = []
    var questionIndex = 0
    var answersCorrect = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var multipleChoiceButtons: [UIButton]!
    @IBOutlet var booleanButtons: [UIButton]!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in multipleChoiceButtons {
            button.applyDesign()
        }
        for button in booleanButtons {
            button.applyDesign()
            button.setTitleColor(UIColor.black, for: .normal)
        }
        
        updateUI()
    }
    
    
    
    func updateUI() {
        navigationItem.title = "Question \(questionIndex + 1)"
        questionLabel.text = questions[questionIndex].question.removingHTMLEntities
        
        if questions[questionIndex].type == "multiple" {
            for button in multipleChoiceButtons {
                button.isHidden = false
            }
            for button in booleanButtons {
                button.isHidden = true
            }
            var answers: [String] = []
            for answer in questions[questionIndex].incorrect_answers {
                answers.append(answer.removingHTMLEntities)
            }
            answers.append(questions[questionIndex].correct_answer.removingHTMLEntities)
            answers = answers.shuffled()
            for (i, button) in multipleChoiceButtons.enumerated() {
                button.backgroundColor = UIColor.darkGray
                button.setTitle(answers[i], for: .normal)
            }
        }
        else if questions[questionIndex].type == "boolean" {
            for button in booleanButtons {
                button.isHidden = false
            }
            for button in multipleChoiceButtons {
                button.isHidden = true
            }
            booleanButtons[0].backgroundColor = UIColor(red: 123/255, green: 239/255, blue: 178/255, alpha: 1)
//            booleanButtons[0].setTitle("True", for: .normal)
            booleanButtons[1].backgroundColor = UIColor(red: 236/255, green: 100/255, blue: 75/255, alpha: 1)
//            booleanButtons[1].setTitle("False", for: .normal)
        }
        progressView.setProgress(Float(questionIndex) / Float(questions.count), animated: true)
    }
    
    func nextQuestion() {
        correctAnswerLabel.text = ""
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "ResultSegue", sender: nil)
        }
    }
    
    
    
    @IBAction func multipleChoiceButtonTapped(_ sender: UIButton) {

        if sender.currentTitle == questions[questionIndex].correct_answer.removingHTMLEntities {
            answersCorrect += 1
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
            correctAnswerLabel.text = questions[questionIndex].correct_answer.removingHTMLEntities
        }
        
        // delay next question to make green / red color visible
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nextQuestion()
        }
        
    }
    
    @IBAction func booleanButtonTapped(_ sender: UIButton) {
        if sender.currentTitle == questions[questionIndex].correct_answer {
            answersCorrect += 1
            correctAnswerLabel.text = "You're right!"
        } else {
            correctAnswerLabel.text = "Correct answer: \(questions[questionIndex].correct_answer)"
        }
        
        // delay next question to make green / red color visible
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nextQuestion()
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultSegue" {
            let resultViewController = segue.destination as! ResultViewController
            resultViewController.questions = questions
            resultViewController.answersCorrect = answersCorrect
        }
    }
}
