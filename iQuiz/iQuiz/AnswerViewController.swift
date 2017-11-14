//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Kiwon Jeong on 2017. 11. 12..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var ans1Label: UILabel!
    @IBOutlet weak var ans2Label: UILabel!
    @IBOutlet weak var ans3Label: UILabel!
    @IBOutlet weak var ans4Label: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    public var isNext = true
    public var ansSelected = ""
    public var subjectChoice = 0
    public var totalIndex = 0
    private var currIndex = 0
    func setCurrIndex(_ incoming: Int) {
        self.currIndex = incoming
    }
    
    private var answers: [String] = []
    func setAnswers(_ incoming: [String]) {
        self.answers = incoming
    }
    private var question: String = ""
    func setQuestion(_ incoming: String) {
        self.question = incoming
    }
    private var answer = ""
    func setAnswer(_ incoming: String) {
        self.answer = incoming
    }
    private var score:Int = 0
    func setScore(_ incoming: Int) {
        self.score = incoming
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.backToList(sender:)))
        
        formatScreen()
        formatResult()
    }
    
    private func formatScreen() {
        questionLabel.text = question
        ans1Label.text = "1) " + answers[0]
        ans2Label.text = "2) " + answers[1]
        ans3Label.text = "3) " + answers[2]
        ans4Label.text = "4) " + answers[3]
    }
    
    private func formatResult() {
        ans1Label.alpha = 0.2
        ans2Label.alpha = 0.2
        ans3Label.alpha = 0.2
        ans4Label.alpha = 0.2
        
        if (answer == ansSelected) {
            score = score + 1
            resultLabel.text = "O"
            switch answer {
            case "1":
                ans1Label.backgroundColor = UIColor(red:0.23, green:0.18, blue:0.68, alpha:1.0)
                ans1Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans1Label.alpha = 1
            case "2":
                ans2Label.backgroundColor = UIColor(red:0.23, green:0.18, blue:0.68, alpha:1.0)
                ans2Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans2Label.alpha = 1
            case "3":
                ans3Label.backgroundColor = UIColor(red:0.23, green:0.18, blue:0.68, alpha:1.0)
                ans3Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans3Label.alpha = 1
            default:
                ans4Label.backgroundColor = UIColor(red:0.23, green:0.18, blue:0.68, alpha:1.0)
                ans4Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans4Label.alpha = 1
            }
        } else {
            resultLabel.text = "X"
            switch answer {
            case "1":
                ans1Label.backgroundColor = UIColor(red:0.42, green:0.83, blue:0.58, alpha:1.0)
                ans1Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans1Label.alpha = 1
            case "2":
                ans2Label.backgroundColor = UIColor(red:0.42, green:0.83, blue:0.58, alpha:1.0)
                ans2Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans2Label.alpha = 1
            case "3":
                ans3Label.backgroundColor = UIColor(red:0.42, green:0.83, blue:0.58, alpha:1.0)
                ans3Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans3Label.alpha = 1
            default:
                ans4Label.backgroundColor = UIColor(red:0.42, green:0.83, blue:0.58, alpha:1.0)
                ans4Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans4Label.alpha = 1
            }
            switch ansSelected {
            case "1":
                ans1Label.backgroundColor = UIColor(red:0.94, green:0.17, blue:0.31, alpha:1.0)
                ans1Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans1Label.alpha = 1
            case "2":
                ans2Label.backgroundColor = UIColor(red:0.94, green:0.17, blue:0.31, alpha:1.0)
                ans2Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans2Label.alpha = 1
            case "3":
                ans3Label.backgroundColor = UIColor(red:0.94, green:0.17, blue:0.31, alpha:1.0)
                ans3Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans3Label.alpha = 1
            default:
                ans4Label.backgroundColor = UIColor(red:0.94, green:0.17, blue:0.31, alpha:1.0)
                ans4Label.textColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
                ans4Label.alpha = 1
            }
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if (isNext) {
            performSegue(withIdentifier: "ReQuestionSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "FinishSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "ReQuestionSegue") {
            let dest = segue.destination as! QuestionViewController
            dest.setScore(score)
            currIndex = currIndex + 1
            dest.setCurrIndex(currIndex)
            dest.subjectChoice = self.subjectChoice
        } else if (segue.identifier! == "FinishSegue") {
            let dest = segue.destination as! FinishViewController
            dest.setScore(score)
            dest.totalIndex = self.totalIndex
        }

    }
    
    @objc func backToList(sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
