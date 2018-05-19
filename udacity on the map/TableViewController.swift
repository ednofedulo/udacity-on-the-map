//
//  TableViewController.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 15/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import UIKit

class TableViewController: BaseController {
    @IBOutlet weak var studentsTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        
        configureNavBar()
    }
    @IBAction func refresh(_ sender: Any) {
        ParseClient.sharedInstance().loadLocations(completionHandler: completionHandler)
    }
    
    func completionHandler(_ success: Bool, _ error: String?) {
        if success {
            DispatchQueue.main.async {
                self.studentsTableView.reloadData()
            }
        } else {
            print(error!)
        }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ParseClient.sharedInstance().studentsInformations?.count)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let student = ParseClient.sharedInstance().studentsInformations![indexPath.row]
        if let toOpen = student.mediaURL {
            let url = URL(string: toOpen)
            if url != nil, app.canOpenURL(url!) {
                app.open(url!, options: [:])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = ParseClient.sharedInstance().studentsInformations![indexPath.row]
        let cellRow = tableView.dequeueReusableCell(withIdentifier: "cellrow")!
        cellRow.imageView?.image = UIImage(named: Constants.UI.PinIcon)
        
        cellRow.textLabel?.text = "\(student.firstName ?? "nil" ) \(student.lastName ?? "nil" )"
        cellRow.detailTextLabel?.text = student.mediaURL ?? "nil"
        
        return cellRow
    }
    
}
