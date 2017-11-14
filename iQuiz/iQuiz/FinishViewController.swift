//
//  FinishViewController.swift
//  iQuiz
//
//  Created by Kiwon Jeong on 2017. 11. 12..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {
    @IBOutlet weak var descripText: UILabel!
    @IBOutlet weak var scoreBoard: UILabel!
    public var totalIndex = 0
    
    private var score:Int = 0
    func setScore(_ incoming: Int) {
        self.score = incoming
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.backToList(sender:)))
        formatLabels()
    }

    private func formatLabels() {
        let total = totalIndex + 1
        scoreBoard.text = "\(score) / \(total)"
        var descComment = ""
        if (total == score) {
            descComment = "Perfect!"
        } else if (score > (total / 2)) {
            descComment = "Almost!"
        } else {
            descComment = "Try Harder!"
        }
        descripText.text = descComment
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backToList(sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
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
