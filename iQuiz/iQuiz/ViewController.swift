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
    private let defaultURL = "https://tednewardsandbox.site44.com/questions.json"
    private var json: Any?
    private var isSuccessful = false
    @IBOutlet weak var subjectTable: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var iQuizLabel: UILabel!
    
    @IBAction func settingPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Setting", message: "Enter URL for different quiz", preferredStyle: .alert)
        
        let checkBtn = UIAlertAction(title: "Check now", style: .default, handler: {
            check -> Void in
            self.spinner.startAnimating()
            self.iQuizLabel.text = ""
            let newURL = alert.textFields![0] as UITextField
            self.retrieveData(newURL.text!)
        })
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .default, handler: {_ in NSLog("Cancel Pressed")
            self.spinner.stopAnimating()
            self.iQuizLabel.text = "iQuiz"
        })
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter URL"
        }
        
        alert.addAction(checkBtn)
        alert.addAction(cancelBtn)
        
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
        isSuccessful = false
        DispatchQueue.global(qos: .userInitiated).async {
            let downloadGroup = DispatchGroup()
            guard let url = URL(string: targetURL) else { return }
            let session = URLSession.shared
            downloadGroup.enter()
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
                downloadGroup.leave()
            }.resume()

            downloadGroup.wait(timeout: .now() + 2)
            self.formatData()
            DispatchQueue.main.async {
                self.iQuizLabel.text = "iQuiz"
                self.spinner.stopAnimating()
                if (self.isSuccessful) {
                    self.subjectTable.reloadData()
                } else if (target != nil) {
                    self.iQuizLabel.text = "No Data Found"
                }
            }
        }

    }
    
    private func writeJSON(_ jsonData: Data) {
        let fileManager = FileManager.default.temporaryDirectory
        let jsonUrl = fileManager.appendingPathComponent("quiz_data.json")
        try? jsonData.write(to: jsonUrl)
    }
    
    private func formatData() {
        if (!isSuccessful) {
            let asset = NSDataAsset(name: "quiz_default_data", bundle: Bundle.main)
            json = try! JSONSerialization.jsonObject(with: asset!.data, options: [])
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
