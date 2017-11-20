//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Kiwon Jeong on 2017. 11. 12..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var ans1btn: UIButton!
    @IBOutlet weak var ans2btn: UIButton!
    @IBOutlet weak var ans3btn: UIButton!
    @IBOutlet weak var ans4btn: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    public var subjectChoice = 0
    public var isSuccssful = false
    private var totalIndex = 0
    private var currIndex = 0
    private var answer = ""
    private var subjects: [Any] = []
    private var json: Any?
    private var ansSelected = ""
    private var score:Int = 0
    
    func setScore(_ incoming: Int) {
        self.score = incoming
    }
    
    func setCurrIndex(_ incoming: Int) {
        self.currIndex = incoming
    }
    
    func getCurrIndex() -> Int {
        return self.currIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.backToList(sender:)))
        readJSON(isSuccssful)

        changeColor()
        formatQuestions()
    }
    
    private func readJSON(_ isNewData: Bool) {
        var path: String
        
        if (isNewData) {
            path = NSTemporaryDirectory() + "quiz_data.json"
            let url = URL(fileURLWithPath: path)
            let data = try! Data(contentsOf: url)
            json = try! JSONSerialization.jsonObject(with: data, options: [])
        } else {
            let asset = NSDataAsset(name: "quiz_default_data", bundle: Bundle.main)
            json = try! JSONSerialization.jsonObject(with: asset!.data, options: [])
        }
        subjects = self.json as! [Any]
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if (ansSelected != "") {
            performSegue(withIdentifier: "AnswerSegue", sender: nil)
        } else {
            sender.setTitle("Choose your answer!", for: .normal)
        }
    }
    
    private func formatQuestions() {
        let item = subjects[subjectChoice] as? [String: Any]
        let questions = item!["questions"] as? [Any]
        totalIndex = (questions?.count)! - 1
        let qContents = questions![currIndex] as? [String: Any]
        answer = qContents!["answer"] as! String
        let answers = qContents!["answers"] as? [Any]
        
        questionLabel.text = qContents!["text"] as? String
        ans1btn.setTitle("1) " + (answers![0] as? String)!, for: .normal)
        ans2btn.setTitle("2) " + (answers![1] as? String)!, for: .normal)
        ans3btn.setTitle("3) " + (answers![2] as? String)!, for: .normal)
        ans4btn.setTitle("4) " + (answers![3] as? String)!, for: .normal)
    }
    
    @objc func backToList(sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ansBtnPressed(_ sender: UIButton) {
        changeColor()
        submitBtn.setTitle("Submit", for: .normal)
        storeSelection(sender.title(for: .normal)!)
        sender.backgroundColor = UIColor(red:0.29, green:0.30, blue:0.78, alpha:1.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "AnswerSegue") {
            let dest = segue.destination as! AnswerViewController
            
            let item = subjects[subjectChoice] as? [String: Any]
            let questions = item!["questions"] as? [Any]
            let qContents = questions![currIndex] as? [String: Any]
            let answers = qContents!["answers"] as? [Any]
            var answerArray: [String] = []
            for each in answers! {
                answerArray.append(each as! String)
            }
            dest.totalIndex = self.totalIndex
            dest.setAnswers(answerArray)
            dest.setQuestion(qContents!["text"] as! String)
            dest.setCurrIndex(self.currIndex)
            dest.ansSelected = self.ansSelected
            dest.subjectChoice = self.subjectChoice
            dest.setScore(score)
            dest.setAnswer(answer)
            if (currIndex == totalIndex) {
                dest.isNext = false
            }
        }
    }
    
    private func storeSelection(_ ansUnformatted: String) {
        let ans = ansUnformatted.components(separatedBy: ")")
        ansSelected = ans[0]
    }
    
    private func changeColor() {
        ans1btn.backgroundColor = UIColor(red:0.52, green:0.56, blue:0.91, alpha:1.0)
        ans2btn.backgroundColor = UIColor(red:0.52, green:0.56, blue:0.91, alpha:1.0)
        ans3btn.backgroundColor = UIColor(red:0.52, green:0.56, blue:0.91, alpha:1.0)
        ans4btn.backgroundColor = UIColor(red:0.52, green:0.56, blue:0.91, alpha:1.0)
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
