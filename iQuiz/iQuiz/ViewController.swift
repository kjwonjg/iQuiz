//
//  ViewController.swift
//  iQuiz
//
//  Created by Kiwon Jeong on 2017. 11. 4..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var subjects: [Any] = []
    private let imageNames = ["math", "shield", "science"]
    private let defaultURL = "https://tednewardsandboxx.site44.com/questions.json"
    private var json: Any?
    private var isSuccessful = false
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
        
        let item = subjects[indexPath.row] as? [String: Any]
        cell.textLabel?.text = item!["title"] as? String
        cell.detailTextLabel?.text = item!["desc"] as? String
        cell.imageView?.image = UIImage(named: imageNames[indexPath.row])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "QuestionSegue", sender: indexPath.row)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "QuestionSegue") {
            let dest = segue.destination as! QuestionViewController
            
            let item = subjects[(sender as! Int)] as? [String: Any]
            dest.navigationItem.title = item!["title"] as? String
            dest.subjectChoice = sender as! Int
            dest.isSuccssful = self.isSuccessful
        }
    }
    
    private func retrieveData(_ target: String?) {
        var targetURL = ""
        if (target == nil) {
            targetURL = defaultURL
        } else {
            targetURL = target!
        }
        
        guard let url = URL(string: targetURL) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                NSLog("\(response)")
            }
            
            if let data = data {
                do {
                    self.json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonData = try JSONSerialization.data(withJSONObject: self.json!, options: [])
                    self.writeJSON(jsonData)
                    self.isSuccessful = true
                } catch {
                    NSLog("\(error)")
                }
            }
        }.resume()
    }
    
    private func writeJSON(_ jsonData: Data) {
        let fileManager = FileManager.default.temporaryDirectory
        let jsonUrl = fileManager.appendingPathComponent("quiz_data.json")
        try? jsonData.write(to: jsonUrl)
    }
    
    private func formatData() {
        if (!isSuccessful) {
            let path = Bundle.main.path(forResource: "quiz_default_data", ofType: "json", inDirectory: "quiz_default.bundle")!
            let url = URL(fileURLWithPath: path)
            let data = try! Data(contentsOf: url)
            json = try! JSONSerialization.jsonObject(with: data, options: [])
        }
        subjects = self.json as! [Any]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        subjectTable.delegate = self
        subjectTable.dataSource = self
        self.subjectTable.register(UITableViewCell.self, forCellReuseIdentifier: "subjectCell")
        
        self.navigationItem.hidesBackButton = true
        
        retrieveData(nil)
        formatData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
