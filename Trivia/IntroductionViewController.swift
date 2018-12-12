//
//  ViewController.swift
//  Trivia
//
//  Created by Fried on 10/12/2018.
//  Copyright © 2018 Fried. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var pickerData: [String] = []
    var selectedRow = 0
    var amount = 0
    var category = 0
    var difficulty = ""
    var type = ""
    var questions: [Question] = []
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountSlider: UISlider!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet var difficultyButtons: [UIButton]!
    @IBOutlet var typeButtons: [UIButton]!
    @IBOutlet weak var startButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountSlider.setValue(10, animated: true)
        amountLabel.text = "Number of Questions: 10"
                
        for button in difficultyButtons {
            button.applyDesign()
        }
        for button in typeButtons {
            button.applyDesign()
        }
        startButton.applyDesign()
        
        pickerData = ["General Knowledge", "Entertainment: Books", "Entertainment: Film", "Entertainment: Music", "Entertainment: Musicals & Theatres", "Entertainment: Television", "Entertainment: Video Games", "Entertainment: Board Games", "Science & Nature", "Science: Computers", "Science: Mathematics", "Mythology", "Sports", "Geography", "History", "Politics", "Art", "Celebrities", "Animals", "Vehicles", "Entertainment: Comics", "Science: Gadgets", "Entertainment: Japanese Anime & Manga", "Entertainment: Cartoon & Animations"]
    }
    
    @IBAction func sliderDragged(_ sender: UISlider) {
        amountLabel.text = "Number of Questions: \(String(Int(sender.value)))"
    }
    
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    /// easy, medium or hard
    @IBAction func difficultyTapped(_ sender: UIButton) {
        for button in difficultyButtons {
            button.backgroundColor = UIColor.darkGray
        }
        sender.backgroundColor = UIColor.lightGray
        
        difficulty = sender.title(for: .normal)!.lowercased()
    }
    
    ///  multiple choice or boolean
    @IBAction func typeTapped(_ sender: UIButton) {
        for button in typeButtons {
            button.backgroundColor = UIColor.darkGray
        }
        sender.backgroundColor = UIColor.lightGray

        if sender.title(for: .normal)! == "Multiple Choice" {
            type = "multiple"
        } else {
            type = "boolean"
        }
    }
    
    
    @IBAction func startTapped(_ sender: UIButton) {
        amount = Int(amountSlider.value)
        category = selectedRow + 9
        TriviaController.shared.getData(amount: amount, category: category, difficulty: difficulty, type: type) { (questions) in
            if let questions = questions {
                self.questions = questions
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "QuestionSegue", sender: IntroductionViewController.self)
            }
            
        }
        
    }
    
    /// pass questions list to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QuestionSegue" {
            let destination = segue.destination as! UINavigationController
            let questionViewController = destination.topViewController as! QuestionViewController
            questionViewController.questions = questions
        }
    }
    
    @IBAction func unwindToIntroduction(segue: UIStoryboardSegue) {
        viewDidLoad()
    }
}


extension UIButton {
    func applyDesign() {
        self.backgroundColor = UIColor.darkGray
        self.layer.cornerRadius = self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
