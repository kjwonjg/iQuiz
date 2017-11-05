//
//  ViewController.swift
//  iQuiz
//
//  Created by Kiwon Jeong on 2017. 11. 4..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let subjects = ["Mathematics", "Marvel Super Heroes", "Science"]
    private let imageNames = ["math", "shield", "science"]
    private let subjectDesc = ["Arithmetic questions", "Marvel comics questions", "Rules of the universe"]
    @IBOutlet weak var subjectTable: UITableView!
    
    @IBAction func settingPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Setting Alert", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated:true, completion: nil)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subjectCell")

        cell.textLabel?.text = subjects[indexPath.row]
        cell.detailTextLabel?.text = subjectDesc[indexPath.row]
        cell.imageView?.image = UIImage(named: imageNames[indexPath.row])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        subjectTable.dataSource = self
        self.subjectTable.register(UITableViewCell.self, forCellReuseIdentifier: "subjectCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

